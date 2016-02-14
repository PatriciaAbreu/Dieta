//
//  App.swift
//  BasicSDK
//
//  Created by Rafael Moris on 21/07/15.
//  Copyright (c) 2015 Interacton. All rights reserved.
//

import Foundation
import UIKit

class App: NSObject {
    class func versionApp()->String {
        return (NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]) as! String
    }
    
    static var rootViewController:UIViewController? {
        get {
            return UIApplication.sharedApplication().keyWindow?.rootViewController
        }
    }
}