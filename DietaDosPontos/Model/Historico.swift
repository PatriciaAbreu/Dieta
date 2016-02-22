//
//  Historico.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 21/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import Foundation

class Historico {
    subscript (index:Int)-> Item {
        return self.itens[index]
    }
    
    var titulo:String
    var itens:[Item]!
    var totalDePontos:Int!
    var count:Int { return self.itens.count }
    
    init(titulo:String, itens:[Item], totalDePontos:Int) {
        self.titulo = titulo
        self.itens = itens
        self.totalDePontos = totalDePontos
    }
    
    func append(item:Item) {
        self.itens.append(item)
    }
    
    func removeAtIndex(index:Int) {
        self.itens.removeAtIndex(index)
    }
}