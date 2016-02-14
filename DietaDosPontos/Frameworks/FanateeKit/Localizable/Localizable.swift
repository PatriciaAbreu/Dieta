//
//  Localizable.swift
//  BasicSDK
//
//  Created by Rafael Moris on 23/07/15.
//  Copyright (c) 2015 Interacton. All rights reserved.
//

import UIKit

class Localizable: NSObject {
    class func localize(key:String)->String {
        return NSLocalizedString(key, comment: "")
    }
    
    class func localize(key:String, comment:String)->String {
        return NSLocalizedString(key, comment: comment)
    }
}
