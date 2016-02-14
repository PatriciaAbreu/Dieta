//
//  HistoricoObject.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 13/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import Foundation
import RealmSwift

class HistoricoObject:Object {
    dynamic var identifier:String = ""
    dynamic var date:NSDate?
}