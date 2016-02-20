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
    
    var feedbackView:UIImageView!
    
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
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text
        
        if text == nil || text!.isEmpty {
            self.filtrarDadosDaBusca("")
        }else {
            self.filtrarDadosDaBusca(text!)
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
                        item in
                        
                        let textoBusca = textoDaBusca.lowercaseString.versaoSemAcento()
                        let textoItem = item.tipo.lowercaseString.versaoSemAcento()
                        
                        return textoItem.containsString(textoBusca)
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
                    item in
                    
                    let textoBusca = textoDaBusca.lowercaseString.versaoSemAcento()
                    let textoItem = item.tipo.lowercaseString.versaoSemAcento()
                    
                    return textoItem.containsString(textoBusca)
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
            cell.itemID = self.dadosFiltrados[indexPath.section][indexPath.row].itemID
            cell.controller = self
            return cell
        }else {
            var cell:DefaultCell!
            if Device.isPad() {
                cell = self.tableView.dequeueReusableCellWithIdentifier("DefaultCellPad") as! DefaultCell
            }else {
                cell = self.tableView.dequeueReusableCellWithIdentifier("DefaultCell") as! DefaultCell
            }
            
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
        
        self.menuViewController?.tableView?.reloadData()
        
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
    
    func feedbackAdd(button:AddButton) {
        if self.feedbackView == nil {
            let img =
            UIImage(named: "btn_added")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.feedbackView = UIImageView(image: img)
            self.feedbackView.tintColor = UIColor(hexString: "#007AFF")
            
            self.navigationController!.view.addSubview(self.feedbackView)
        }
    
        self.navigationController!.view.bringSubviewToFront(self.feedbackView)
        
        self.feedbackView.alpha = 0.0
        self.feedbackView.center = self.navigationController!.view.convertPoint(button.center, fromView: button.superview!)
        
        UIView.animateWithDuration(0.25) { () -> Void in
            self.feedbackView.frame = CGRect(origin: self.feedbackView.frame.origin, size: CGSize(width: 32, height: 32))
            self.feedbackView.alpha = 1.0
        }
        
        delay(0.25) { () -> () in
            UIView.animateWithDuration(0.5) { () -> Void in
                self.feedbackView.frame = CGRect(origin: CGPoint(x: 25, y: 35), size: CGSize(width: 10, height: 10))
                self.feedbackView.alpha = 0.5
            }
            
            delay(0.5) { () -> () in
                UIView.animateWithDuration(0.25) { () -> Void in
                    self.feedbackView.frame = CGRect(origin: CGPoint(x: 25, y: 35), size: CGSize(width: 0, height: 0))
                    self.feedbackView.alpha = 0.0
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.mostrandoHistorico
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.apagarRowAtIndexPath(indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        if self.mostrandoHistorico {
            return UITableViewCellEditingStyle.Delete
        }else {
            return UITableViewCellEditingStyle.Insert
        }
    }
    
    func apagarRowAtIndexPath(indexPath:NSIndexPath) {
        var apagarSessao = false
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! RemoveCell
        
        let database = RealmManager.sharedInstance()
        
        let itens = database.objectsOfType(ItemObject.self, identifier: "itemID", value: cell.itemID)
        if let item = itens?.first {
            let identifier = item.identifier
            database.delete(item)
            
            if database.hasObjectOfType(ItemObject.self, withIdentifier:identifier) == false {
                let historicos = database.objectsOfType(HistoricoObject.self, withIdentifier: identifier)
                if let historico = historicos?.first {
                    database.delete(historico)
                    apagarSessao = true
                }
            }
        }
        
        if apagarSessao {
            self.dadosFiltrados.removeAtIndex(indexPath.section)
            
            self.tableView.deleteSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Top)
        }else {
            self.dadosFiltrados[indexPath.section].removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
            
            delay(0.5, closure: { () -> () in
                self.reloadDataUpdateTable()
            })
        }
    }
}

