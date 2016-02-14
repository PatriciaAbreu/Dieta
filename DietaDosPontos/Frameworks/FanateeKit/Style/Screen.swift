//
//  Screen.swift
//  BasicSDK
//
//  Created by Rafael Moris on 21/07/15.
//  Copyright (c) 2015 Interacton. All rights reserved.
//

import Foundation
import UIKit

class Screen: NSObject {
    static var nativeScale:CGFloat {
        return UIScreen.mainScreen().nativeScale
    }
    
    class func bounds()->CGRect {
        return UIScreen.mainScreen().bounds
    }
    
    class func size()->CGSize {
        return bounds().size
    }
    
    class func width()->CGFloat {
        return bounds().width
    }
    
    class func height()->CGFloat {
        return bounds().height
    }
    
    class func minX()->CGFloat {
        return CGRectGetMinX(bounds())
    }
    class func minY()->CGFloat {
        return CGRectGetMinY(bounds())
    }
    
    class func midX()->CGFloat {
        return CGRectGetMidX(bounds())
    }
    
    class func midY()->CGFloat {
        return CGRectGetMidY(bounds())
    }
    
    class func maxX()->CGFloat {
        return CGRectGetMaxX(bounds())
    }
    
    class func maxY()->CGFloat {
        return CGRectGetMaxY(bounds())
    }
    
    class func centerPoint()->CGPoint {
        return CGPoint(x: midX(), y: midY())
    }
}
