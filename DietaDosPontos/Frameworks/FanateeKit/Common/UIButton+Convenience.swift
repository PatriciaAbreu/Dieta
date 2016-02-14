//
//  UIButton+Convenience.swift
//  Era Uma Vez
//
//  Created by Rafael Moris on 28/10/15.
//  Copyright © 2015 Gabi Gaiofatto. All rights reserved.
//

import UIKit

extension UIButton {
    convenience init(imageNamed:String, target:AnyObject?, action: Selector?) {
        let image = UIImage(named: imageNamed)
        let posY = Screen.maxY() - image!.size.height * 1.5
        
        let rect = CGRect(x: image!.size.height * 0.5, y: posY, width: image!.size.width, height: image!.size.height)
        
        self.init(frame: rect)
        self.setImage(image, forState: UIControlState())
        
        if target != nil && action != nil {
            self.addTarget(target!, action: action!, forControlEvents: UIControlEvents.TouchUpInside)
        }
    }
}

