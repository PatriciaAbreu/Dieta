//
//  DefaultCell.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 11/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import Foundation
import UIKit

class RemoveCell: UITableViewCell {
    var controller:MainTableViewController!
    
    @IBOutlet weak var btnRemover: AddButton!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblQuantidade: UILabel!
    @IBOutlet weak var lblPontos: UILabel!
    
    func definirValoresBaseadoNoItem(item:Item, section:Int, row:Int) {
        self.lblTipo.text = item.tipo
        self.lblQuantidade.text = item.quantidade
        self.lblPontos.text = String(item.pontos)
        self.btnRemover.section = section
        self.btnRemover.row = row
    }
    
    @IBAction func removerPontos(sender: AnyObject) {
        let button = sender as! AddButton

        let database = RealmManager.sharedInstance()
        
        let itens = database.objectsOfType(ItemObject.self, identifier: "itemID", value: button.itemID)
        if let item = itens?.first {
            let identifier = item.identifier
            database.delete(item)
            
            if database.hasObjectOfType(ItemObject.self, withIdentifier:identifier) == false {
                let historicos = database.objectsOfType(HistoricoObject.self, withIdentifier: identifier)
                if let historico = historicos?.first {
                    database.delete(historico)
                }
            }
        }
        
        self.controller.reloadDataUpdateTable()
    }
    
}