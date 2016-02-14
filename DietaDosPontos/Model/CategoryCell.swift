//
//  CategoryCell.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 13/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import Foundation
import UIKit

class CategoryCell: UITableViewCell {
    @IBOutlet weak var lblCategoria: UILabel!
    
    func definirValoresBaseadoNoItem(categoria:Categoria) {
        self.lblCategoria.text = categoria.nome
    }
}