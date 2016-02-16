//
//  NSString+StringExtesion.swift
//  BasicSDK
//
//  Created by Rafael Moris on 20/10/15.
//  Copyright © 2015 Interacton. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func versaoSemAcento()->String {
        return self.stringByFoldingWithOptions(NSStringCompareOptions.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())
    }
    
    static func isNilOrWhiteSpace(var message:String?)->Bool {
        if message == nil {
            return true
        }
        let set:NSCharacterSet = NSCharacterSet(charactersInString: " \t\n\r ")
        message = message!.stringByTrimmingCharactersInSet(set)
        
        return message!.isEmpty
    }
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start: start, end: end)]
    }
    
    var count:Int {
        return self.characters.count
    }
}