//
//  Notification.swift
//  DietaDosPontos
//
//  Created by Patricia Machado de Abreu on 2/12/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import UIKit
import EventKit

var device: NSData!
var notif: UILocalNotification!

class Notification: UIViewController {
//    static let shared = Notification()
//    
//    var eventStore: EKEventStore!
//    
//    init(){
//        eventStore = EKEventStore()
//    }
//    
//    
//    var localNotification = UILocalNotification()
//    
//    localNotification.alertAction = "Testing"
//    localNotification.alertBody = "Hello World!"
//    localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
//    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    
//    var notification:UILocalNotification = UILocalNotification()

    
    
    notification.alertBody = "Get up and stretch!"
    notification.fireDate = NSDate(timeIntervalSinceNow: 0)
    notification.soundName = UILocalNotificationDefaultSoundName
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
   
}
