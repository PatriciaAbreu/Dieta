//
//  ViewController.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 11/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    static var mainTableView:UITableView!
    
    var menuViewController:MenuViewController!
    var calendarViewController:CalendarViewController!
    var dataSource = [Categoria]()
    var currentDataSource:[Categoria]!
    var dadosFiltrados = [Categoria]()
    var totalDePontos = [Int]()
    let searchController = UISearchController(searchResultsController: nil)
    
    var categoriaSelecionada:String? = nil
    var identificadorSelecionado:String? = nil
    var mostrandoHistorico = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.carregarDataSource()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchBar.barTintColor = UIColor(hexString: "#f0eff4")
        
        MainTableViewController.mainTableView = self.tableView
    }

    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SearchBar
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        if let text = searchController.searchBar.text {
            if !text.isEmpty {
                self.filtrarDadosDaBusca(text)
            }
        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchController.active = false
    }
    
    func filtrarDadosDaBusca(textoDaBusca:String) {
        if self.mostrandoHistorico == false {
            self.currentDataSource = self.dataSource
        }
        self.totalDePontos.removeAll()
        self.dadosFiltrados.removeAll()
        
        if self.categoriaSelecionada == nil {
            for categoria in self.currentDataSource {
                var itens = categoria.itens
                
                if !textoDaBusca.isEmpty && textoDaBusca != " " {
                    itens = itens.filter {
                        item in return item.tipo.lowercaseString.containsString(textoDaBusca.lowercaseString)
                    }
                }
                
                if itens.count > 0 {
                    let novaCategoria = Categoria(nome: categoria.nome)
                    novaCategoria.itens = itens
                    self.dadosFiltrados.append(novaCategoria)
                    
                    var total = 0
                    for item in itens {
                        total += item.pontos
                    }
                    self.totalDePontos.append(total)
                }
            }
        }else {
            let categoria = (self.currentDataSource.filter {
                categoria in return categoria.nome.lowercaseString == self.categoriaSelecionada!.lowercaseString
            }).first!
            
            var itens = categoria.itens
            
            if !textoDaBusca.isEmpty && textoDaBusca != " " {
                itens = itens.filter {
                    item in return item.tipo.lowercaseString.containsString(textoDaBusca.lowercaseString)
                }
            }
            
            if itens.count > 0 {
                let novaCategoria = Categoria(nome: categoria.nome)
                novaCategoria.itens = itens
                self.dadosFiltrados.append(novaCategoria)
            }
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - TableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dadosFiltrados.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dadosFiltrados[section].count
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView.loadFromNib()
        headerView.categoria.text = self.dadosFiltrados[section].nome
        
        if self.mostrandoHistorico {
            headerView.total.text = String(self.totalDePontos[section])
        }
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return self.defaultCellAtIndexPath(indexPath)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func defaultCellAtIndexPath(indexPath:NSIndexPath)-> UITableViewCell {
        if self.mostrandoHistorico {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("RemoveCell") as! RemoveCell
            
            cell.definirValoresBaseadoNoItem(self.dadosFiltrados[indexPath.section][indexPath.row], section: indexPath.section, row: indexPath.row)
            cell.btnRemover.itemID = self.dadosFiltrados[indexPath.section][indexPath.row].itemID
            cell.controller = self
            return cell
        }else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("DefaultCell") as! DefaultCell
            
            cell.definirValoresBaseadoNoItem(self.dadosFiltrados[indexPath.section][indexPath.row], section: indexPath.section, row: indexPath.row)
            cell.controller = self
            return cell
        }
    }
    
    func carregarDataSource() {
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
    }
    
    @IBAction func mostrarCategoria(sender: AnyObject) {
        if self.menuViewController == nil {
            self.menuViewController = MenuViewController.loadFromNib()
            self.menuViewController.controller = self
        }
        self.menuViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(menuViewController, animated: false, completion: nil)
    }
    
    @IBAction func mostrarCalendario(sender: AnyObject) {
        if self.calendarViewController == nil {
            self.calendarViewController = CalendarViewController.loadFromNib()
            self.calendarViewController.controller = self
        }
        self.calendarViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
        self.navigationController?.presentViewController(calendarViewController, animated: false, completion: nil)
    }
    
    func mostrarItensDaCategoriaSelecionada() {
        self.mostrandoHistorico = false
        self.currentDataSource = self.dataSource
        
        self.filtrarDadosDaBusca(" ")
    }
    
    func mostrarItensDoDia(identificador:String?) {
        self.mostrandoHistorico = true
        self.identificadorSelecionado = identificador
        self.categoriaSelecionada = nil
        
        self.totalDePontos.removeAll()
        self.currentDataSource.removeAll()
        self.dadosFiltrados.removeAll()
        
        let database = RealmManager.sharedInstance()
        
        let calendario = NSCalendar.currentCalendar()
        calendario.timeZone = NSTimeZone(abbreviation: "GMT")!
        
        var historicos = database.objectsOfType(HistoricoObject.self)!
        if identificador != nil {
            historicos = database.objectsOfType(HistoricoObject.self, withIdentifier: identificador!)!
        }
        
        historicos = historicos.sorted("date", ascending: false)
        
        for historico in historicos {
            let data = historico.date!
            
            let day = calendario.component(NSCalendarUnit.Day, fromDate: data)
            let month = calendario.component(NSCalendarUnit.Month, fromDate: data)
            let year = calendario.component(NSCalendarUnit.Year, fromDate: data)
            
            let nome = "\(day)/\(month)/\(year)"
            
            let categoria = Categoria(nome: nome)
            
            var itensObject = database.objectsOfType(ItemObject.self, withIdentifier: historico.identifier)!
            
            var itens = [Item]()
            var total = 0
            
            itensObject = itensObject.sorted("date", ascending: true)
            
            for itemObject in itensObject {
                let newItem = Item(tipo: itemObject.tipo, quantidade: itemObject.quantidade, pontos: itemObject.pontos)
                newItem.identifier = itemObject.identifier
                newItem.itemID = itemObject.itemID
                itens.append(newItem)
                
                total += newItem.pontos
            }
            
            self.totalDePontos.append(total)
            categoria.itens = itens
            
            self.currentDataSource.append(categoria)
        }
        
        self.dadosFiltrados = self.currentDataSource
        self.tableView.reloadData()
    }
    
    func reloadDataUpdateTable() {
        if self.mostrandoHistorico {
            self.mostrarItensDoDia(self.identificadorSelecionado)
        }else {
            self.mostrarItensDaCategoriaSelecionada()
        }
    }
}

