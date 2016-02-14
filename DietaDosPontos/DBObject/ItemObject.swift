//
//  ItemDAO.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 13/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import Foundation
import RealmSwift

class ItemObject:Object {
    dynamic var identifier:String = ""
    dynamic var itemID:String = ""
    dynamic var date:NSDate?
    dynamic var tipo:String = ""
    dynamic var quantidade:String = ""
    dynamic var pontos:Int = 0
}