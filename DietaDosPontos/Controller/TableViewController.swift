//
//  ViewController.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 11/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    let defaultCellIdentifier = "DefaultCell"
    var data = [Categoria]()
    var dadosFiltrados = [Categoria]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.carregarDataSource()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.definesPresentationContext = true
        self.tableView.tableHeaderView = self.searchController.searchBar
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
        self.dadosFiltrados.removeAll()
        
        for categoria in self.data {
            let itens = categoria.itens.filter {
                item in return item.tipo.lowercaseString.containsString(textoDaBusca.lowercaseString)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("segue")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dadosFiltrados.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dadosFiltrados[section].count
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView.loadFromNib()
        headerView.categoria.text = self.dadosFiltrados[section].nome
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return self.defaultCellAtIndexPath(indexPath)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    func defaultCellAtIndexPath(indexPath:NSIndexPath)-> DefaultCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(self.defaultCellIdentifier) as! DefaultCell
        
        cell.definirValoresBaseadoNoItem(self.dadosFiltrados[indexPath.section][indexPath.row])
        
        if self.dadosFiltrados[indexPath.section].count - 1 == indexPath.row {
            cell.line.hidden = true
        }
        
        return cell
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
                self.data.append(categoria)
            }
        }
        
        self.dadosFiltrados = self.data
    }
}

