//
//  DataSource.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 21/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import Foundation
import WatchConnectivity
import ClockKit

enum DataSourceType {
    case Categoria, Historico
}

extension DataSource:WCSessionDelegate {
    
}

class DataSource:NSObject {
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    var currentType = DataSourceType.Categoria
    
    var dataSourceHistoricos:[Historico]!
    var currentDataSourceHistorico:[Historico]!
    private var _dadosFiltradosHistorico:[Historico]!
    var dadosFiltradosHistorico:[Historico]! {
        get {
            self.contemModificacoes = false
            return self._dadosFiltradosHistorico
        }
        set {
            self._dadosFiltradosHistorico = newValue
        }
    }
    
    private var dataSource:[Categoria]!
    var currentDataSource:[Categoria]!
    private var _dadosFiltrados:[Categoria]!
    var dadosFiltrados:[Categoria]! {
        get {
            self.contemModificacoes = false
            return self._dadosFiltrados
        }
        set {
            self._dadosFiltrados = newValue
        }
    }
    var contemModificacoes = false
    
    override init() {
        super.init()
        self.dataSource = [Categoria]()
        self.carregarDataSource()
        self.carregarDataSourceHistoricos()
    }
    
    static func sharedInstance()-> DataSource {
        struct Static {
            static let instance:DataSource = DataSource()
        }
        
        return Static.instance
    }
    
    private func carregarDataSource() {
        let path = NSBundle.mainBundle().pathForResource("database", ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSDataReadingOptions.DataReadingMappedIfSafe)
        
        if let jsonResult = try? NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) {
            let json = jsonResult as! [String:AnyObject]
            
            var categorias = json["categorias"] as! [AnyObject]
            for i in 0 ..< categorias.count {
                let categoriaJSON = categorias[i] as! [String:AnyObject]
                let categoria = Categoria(nome: categoriaJSON["nome"] as! String)
                
                let itensJSON = categoriaJSON["itens"] as! [AnyObject]
                for j in 0 ..< itensJSON.count {
                    let itemJSON = itensJSON[j] as! [String:AnyObject]
                    let item = Item(tipo: itemJSON["tipo"] as! String, quantidade: itemJSON["quantidade"] as! String, pontos: itemJSON["pontos"] as! Int)
                    categoria.append(item)
                }
                self.dataSource.append(categoria)
            }
        }
        
        self.currentDataSource = self.dataSource
        self.dadosFiltrados = self.dataSource
        
        self.contemModificacoes = true
    }
    
    func removerFiltros() {
        self.dadosFiltrados = self.currentDataSource
        self.dadosFiltradosHistorico = self.currentDataSourceHistorico
    }
    
    func filtrarPorCategoria(index:Int) {
        self.currentDataSource = self.dataSource
        
        switch index {
        case 0:
            self.removerFiltros()
        default:
            let categoria = self.dataSource[index - 1]
            self.dadosFiltrados.removeAll()
            self.dadosFiltrados.append(categoria)
        }
        
        self.contemModificacoes = true
    }
    
    func filtrarPorHistorico(index:Int) {
        switch index {
        case 0:
            self.removerFiltros()
        default:
            let historico = self.dataSourceHistoricos[index - 1]
            self.dadosFiltradosHistorico.removeAll()
            self.dadosFiltradosHistorico.append(historico)
        }
        
        self.contemModificacoes = true
    }
    
    func carregarDataSourceHistoricos() {
        if WCSession.isSupported() {
            self.session = WCSession.defaultSession()
            
            self.session?.sendMessage(["action": "carregarHistoricos", "identificador": ""], replyHandler: { (response) -> Void in
                
                if let json = response["historicos"] as? String {
                    let historicos = self.criarHistoricoComJSON(json)
                    
                    self.dataSourceHistoricos = historicos
                    self.currentDataSourceHistorico = historicos
                    self.dadosFiltradosHistorico = historicos

                    if HistoricoController.aguardandoDados {
                        HistoricoController.aguardandoDados = false
                        HistoricoController.object.reloadData()
                    }
                }
                
                }, errorHandler: { (error) -> Void in
                    print(error)
            })
        }
    }
    
    private func criarHistoricoComJSON(json:String)-> [Historico] {
        let calendario = NSCalendar.currentCalendar()
        calendario.timeZone = NSTimeZone(abbreviation: "GMT")!
        let dataAtual = ComplicationController.getCurrentLocalDate()
        
        let day = calendario.component(NSCalendarUnit.Day, fromDate: dataAtual)
        let month = calendario.component(NSCalendarUnit.Month, fromDate: dataAtual)
        let year = calendario.component(NSCalendarUnit.Year, fromDate: dataAtual)
        
        let hoje = "\(day)-\(month)-\(year)"
        
        var historicos = [Historico]()
        let jsonData = json.dataUsingEncoding(NSUTF8StringEncoding)
        
        if let jsonResult = try? NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) {
            
            let historicosJSON = jsonResult as! [AnyObject]
            
            for i in 0 ..< historicosJSON.count {
                let historicoJSON = historicosJSON[i] as! [String:AnyObject]
                
                let titulo = historicoJSON["titulo"] as! String
                let total = historicoJSON["totalDePontos"] as! Int
                
                var itens = [Item]()
                let itensJSON = historicoJSON["itens"] as! [AnyObject]
                for j in 0 ..< itensJSON.count {
                    let itemJSON = itensJSON[j] as! [String:AnyObject]
                    let item = Item(tipo: itemJSON["tipo"] as! String, quantidade: itemJSON["quantidade"] as! String, pontos: itemJSON["pontos"] as! Int)
                    item.itemID = itemJSON["itemID"] as! String
                    itens.append(item)
                }
                
                let historico = Historico(titulo: titulo, itens: itens, totalDePontos: total)
                historicos.append(historico)

                if historicoJSON["identifier"] as! String == hoje {
                    let defaults:NSUserDefaults = NSUserDefaults(suiteName: "group.com.paty.rafa.vidaecontrole")!
                    
                    let pontosAntes = defaults.stringForKey("pontosDeHoje")
                    
                    defaults.setObject(String(total), forKey: "pontosDeHoje")
                    defaults.setObject(hoje, forKey: "identificador")
                    
                    if pontosAntes != String(total) {
                        let complicationServer = CLKComplicationServer.sharedInstance()
                        for complication in complicationServer.activeComplications {
                            complicationServer.reloadTimelineForComplication(complication)
                        }
                    }
                }
            }
            
            self.currentDataSourceHistorico = historicos
        }
        
        return historicos
    }
    
    func adicionarPontos(tipo:String, quantidade:String, pontos:Int) {
        if WCSession.isSupported() {
            self.session = WCSession.defaultSession()
            
            self.session?.sendMessage(["action": "adicionarPontos", "tipo": tipo, "quantidade": quantidade, "pontos": pontos], replyHandler: { (response) -> Void in
                
                if let success = response["success"] as? Bool {
                    if success {
                        if let json = response["historicos"] as? String {
                            let historicos = self.criarHistoricoComJSON(json)
                            
                            self.dataSourceHistoricos = historicos
                            self.currentDataSourceHistorico = historicos
                            self.dadosFiltradosHistorico = historicos
                            
                            if HistoricoController.aguardandoDados {
                                HistoricoController.aguardandoDados = false
                                HistoricoController.object.reloadData()
                            }
                            
                            MainController.object.callbackPontosAdicionados()
                        }
                    }
                }
                
                }, errorHandler: { (error) -> Void in
                    print(error)
            })
        }
    }
    
    func removerPontos(itemID:String) {
        if WCSession.isSupported() {
            self.session = WCSession.defaultSession()
            
            self.session?.sendMessage(["action": "removerPontos", "itemID": itemID], replyHandler: { (response) -> Void in
                
                if let success = response["success"] as? Bool {
                    if success {
                        if let json = response["historicos"] as? String {
                            let historicos = self.criarHistoricoComJSON(json)
                            
                            self.dataSourceHistoricos = historicos
                            self.currentDataSourceHistorico = historicos
                            self.dadosFiltradosHistorico = historicos
                            
                            if HistoricoController.aguardandoDados {
                                HistoricoController.aguardandoDados = false
                                HistoricoController.object.reloadData()
                            }
                            
                            self.contemModificacoes = true
                            MainController.object.callbackPontosRemovidos()
                        }
                    }
                }
                
                }, errorHandler: { (error) -> Void in
                    print(error)
            })
        }
    }
}