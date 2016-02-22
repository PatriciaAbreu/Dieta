//
//  InterfaceController.swift
//  applewatch Extension
//
//  Created by Rafael Moris on 20/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import WatchKit
import ClockKit
import Foundation

class MainController: WKInterfaceController  {
    static var object:MainController!
    
    // MARK: - IBOutlets
    @IBOutlet var table: WKInterfaceTable!
    @IBOutlet var lblVazio: WKInterfaceLabel!
    
    //MARK: - Variaveis
    var dataSource:DataSource!
    var totalDePontos = [Int]()
    var rowUltimoItemAdicionado:DefaultRow!
    var rowUltimoItemRemovido:DeleteRow!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        MainController.object = self
        self.dataSource = DataSource.sharedInstance()
    }

    override func willActivate() {
        super.willActivate()
        self.reloadData()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    override func didAppear() {
        super.didAppear()
    }
    
    //MARK: - Tabela
    func reloadData(scrolToZero:Bool = true) {
        if self.dataSource.contemModificacoes == false { return }
        
        self.table.setNumberOfRows(0, withRowType: "")
        
        switch self.dataSource.currentType {
        case .Categoria:
            self.reloadDataCategoria()
        case .Historico:
            self.reloadDataHistorico(scrolToZero)
        }
    }
    
    func reloadDataCategoria() {
        var rowTypes = [String]()
        for item in self.dataSource.dadosFiltrados {
            rowTypes.append("headerRow")
            for _ in item.itens {
                rowTypes.append("defaultRow")
            }
        }
        self.table.setRowTypes(rowTypes)
        
        var index = 0
        for i in 0 ..< self.dataSource.dadosFiltrados.count {
            let session:HeaderRow = self.table.rowControllerAtIndex(index++) as! HeaderRow
            let item = self.dataSource.dadosFiltrados[i]
            
            session.lblTitulo.setText(item.nome)
            
            for j in 0 ..< item.itens.count {
                let row:DefaultRow = self.table.rowControllerAtIndex(index++) as! DefaultRow
                row.tipo = item.itens[j].tipo
                row.quantidade = item.itens[j].quantidade
                row.pontos = item.itens[j].pontos
                row.identificador = item.itens[j].identifier
            }
        }
        
        self.table.scrollToRowAtIndex(0)
    }
    
    func reloadDataHistorico(scrolToZero:Bool = true) {
        if self.dataSource.dadosFiltradosHistorico.count == 0 {
            self.lblVazio.setHidden(false)
        }else {
            self.lblVazio.setHidden(true)
            
            var rowTypes = [String]()
            for item in self.dataSource.dadosFiltradosHistorico {
                rowTypes.append("headerRow")
                for _ in item.itens {
                    rowTypes.append("deleteRow")
                }
            }
            self.table.setRowTypes(rowTypes)
            
            var index = 0
            for i in 0 ..< self.dataSource.dadosFiltradosHistorico.count {
                let session:HeaderRow = self.table.rowControllerAtIndex(index++) as! HeaderRow
                let item = self.dataSource.dadosFiltradosHistorico[i]
                
                session.lblTitulo.setText(item.titulo)
                session.lblTotal.setText(String(item.totalDePontos))
                for j in 0 ..< item.itens.count {
                    let row:DeleteRow = self.table.rowControllerAtIndex(index++) as! DeleteRow
                    
                    row.lblTipo.setText(item.itens[j].tipo)
                    row.lblQuantidade.setText(item.itens[j].quantidade)
                    row.lblPontos.setText(String(item.itens[j].pontos))
                    row.itemID = item.itens[j].itemID
                    row.identificador = item.itens[j].identifier
                }
            }
        }
        
        if scrolToZero {
            self.table.scrollToRowAtIndex(0)
        }
    }
    
    func callbackPontosAdicionados() {
        DefaultRow.processandoRequisicao = false
        
        self.animateWithDuration(0.25) { () -> Void in
            self.rowUltimoItemAdicionado.groupFundoBotao.setBackgroundColor(UIColor(hexString: "#222223"))
        }
    }
    
    func callbackPontosRemovidos() {
        DeleteRow.processandoRequisicao = false
        
        self.animateWithDuration(0.25) { () -> Void in
            self.rowUltimoItemRemovido.groupCelula.setHeight(0)
        }
        
        delay(0.3) {
            self.reloadData(false)
        }
    }
    
    // MARK: - IBAction
    @IBAction func voltar() {
        HistoricoController.object.popController()
    }
    
    @IBAction func mostrarCategorias() {
        self.pushControllerWithName("viewCategorias", context: nil)
    }
    
    
    @IBAction func mostrarHistorico() {
        self.pushControllerWithName("viewHistorico", context: nil)
    }
}
