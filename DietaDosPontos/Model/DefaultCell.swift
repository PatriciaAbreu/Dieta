//
//  DefaultCell.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 11/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import Foundation
import UIKit

class DefaultCell: UITableViewCell {
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var lblTipo: UITextField!
    @IBOutlet weak var lblQuantidade: UITextField!
    @IBOutlet weak var lblPontos: UITextField!
    
    func definirValoresBaseadoNoItem(item:Item) {
        self.lblTipo.text = item.tipo
        self.lblQuantidade.text = item.quantidade
        self.lblPontos.text = String(item.pontos)
    }
}