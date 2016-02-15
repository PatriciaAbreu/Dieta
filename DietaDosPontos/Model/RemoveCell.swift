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
    
    var itemID:String!
    var section:Int!
    var row:Int!
    
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblQuantidade: UILabel!
    @IBOutlet weak var lblPontos: UILabel!
    
    func definirValoresBaseadoNoItem(item:Item, section:Int, row:Int) {
        self.lblTipo.text = item.tipo
        self.lblQuantidade.text = item.quantidade
        self.lblPontos.text = String(item.pontos)
        
        self.itemID = item.itemID
        self.section = section
        self.row = row
    }
}