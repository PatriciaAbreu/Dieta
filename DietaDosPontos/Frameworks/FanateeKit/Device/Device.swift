//
//  Device.swift
//  BasicSDK
//
//  Created by Rafael Moris on 21/07/15.
//  Copyright (c) 2015 Interacton. All rights reserved.
//

import Foundation
import UIKit

class Device: NSObject {
    
    class func language()->String {
        return NSLocale.preferredLanguages().first!
    }
    
    class func model()->String {
        return DeviceInfo.model()
    }
    
    class func numberModel()->Int {
        return Int(UIDevice.currentDevice().systemVersion)!
    }
    
    class func versionOS()->String {
        return UIDevice.currentDevice().systemVersion
    }
    
    class func hasNetworkConnection()->Bool {
        return DeviceInfo.hasNetworkConnection()
    }
    
    class func isPad()->Bool {
        return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad
    }
    
    class func isPhone()->Bool {
        return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone
    }
    
    class func isPhone6Plus()->Bool {
        let versao = UIDevice.currentDevice().systemVersion.componentsSeparatedByString(".")
        
        if (Int(versao[0]) < 8) {
            return false;
        }
        
        return UIScreen.mainScreen().nativeScale > 2;
    }
    
    class func isPhone6()->Bool {
        return (Screen.width() == 667.0 && Screen.height() == 375.0) || (Screen.width() == 375.0 && Screen.height() == 667.0)
    }
    
    class func isTV()->Bool {
        return (!isPhone() && !isPad())
    }
}
