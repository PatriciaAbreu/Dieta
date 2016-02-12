//
//  Item.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 11/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import Foundation

class Item {
    var tipo:String!
    var quantidade:String
    var pontos:Int!
    
    init(tipo:String, quantidade:String, pontos:Int) {
        self.tipo = tipo
        self.quantidade = quantidade
        self.pontos = pontos
    }
}