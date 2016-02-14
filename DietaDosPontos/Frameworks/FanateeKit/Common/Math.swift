//
//  Math.swift
//  Crypto
//
//  Created by Rafael Moris on 29/10/15.
//  Copyright © 2015 Fanatee. All rights reserved.
//

import Foundation

class Math {
    class func random(min:Int, max:Int)-> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    class func ruleOfThree(first first:Double?, second:Double?, third:Double?, fourth:Double?)->Double? {
        
        if (first == nil && (second == nil || third == nil || fourth == nil)) {
            return nil
        }
        if (second == nil && (first == nil || third == nil || fourth == nil)) {
            return nil
        }
        if (third == nil && (first == nil || second == nil || fourth == nil)) {
            return nil
        }
        if (fourth == nil && (first == nil || second == nil || third == nil)) {
            return nil
        }
        
        var x:Double?
        if (first == nil && (second != nil && third != nil && fourth != nil)) {
            x = second! * third!
            x = x! / fourth!
        }
        if (second == nil && (first != nil && third != nil && fourth != nil)) {
            x = first! * fourth!
            x = x! / third!
        }
        if (third == nil && (first != nil && second != nil && fourth != nil)) {
            x = first! * fourth!
            x = x! / second!
        }
        if (fourth == nil && (first != nil && second != nil && third != nil)) {
            x = second! * third!
            x = x! / first!
        }
        return x
    }
}