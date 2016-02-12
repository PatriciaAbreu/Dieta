//
//  Categoria.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 11/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import Foundation

class Categoria {
    var nome:String
    var itens:[Item]!
    
    subscript (index:Int)-> Item {
        return self.itens[index]
    }
    
    var count:Int { return self.itens.count }
    
    init(nome:String) {
        self.nome = nome
        self.itens = [Item]()
    }
    
    func append(item:Item) {
        self.itens.append(item)
    }
    
    func removeAtIndex(index:Int) {
        self.itens.removeAtIndex(index)
    }
}