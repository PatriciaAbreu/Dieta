//
//  CategoryCell.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 13/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import Foundation
import UIKit

class CalendarCell: UITableViewCell {
    var identifier = ""
    @IBOutlet weak var lblData: UILabel!
    
    func definirValoresBaseadoDataString(dataString:String) {
        self.lblData.text = dataString
    }
}