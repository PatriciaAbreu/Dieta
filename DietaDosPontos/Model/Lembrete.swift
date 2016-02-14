//
//  Lembrete.swift
//  DietaDosPontos
//
//  Created by Patricia Machado de Abreu on 2/12/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import UIKit

class Lembrete {
    var notification:UILocalNotification!
    
    static func gerarLembretesParaXDias(dias:Int) {
        let calendario = NSCalendar.currentCalendar()
        calendario.timeZone = NSTimeZone(abbreviation: "GMT")!
        var dataAtual = NSDate()
        
        for dia in 0 ..< dias {
            dataAtual.dateByAddingTimeInterval(NSTimeInterval(60 * 60 * 24 * dia))
            for var hora = 7; hora <= 19; hora += 3 {
                dataAtual = calendario.dateBySettingHour(hora, minute: 0, second: 0, ofDate: dataAtual, options: NSCalendarOptions(rawValue: 0))!
                
                let lembrete = Lembrete()
                lembrete.notification = UILocalNotification()
                lembrete.notification.timeZone = calendario.timeZone
                
                switch hora {
                case 7:
                    lembrete.notification.alertBody = "Algo as 6"
                case 10:
                    lembrete.notification.alertBody = "Algo as 9"
                case 13:
                    lembrete.notification.alertBody = "Algo as 12"
                case 16:
                    lembrete.notification.alertBody = "Algo as 15"
                case 19:
                    lembrete.notification.alertBody = "Algo as 18"
                default:
                    break;
                }
                
                lembrete.notification.fireDate = dataAtual
                UIApplication.sharedApplication().scheduleLocalNotification(lembrete.notification)
            }
        }
        self.printNotifications()
    }
    
    static func printNotifications() {
        let notifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        for notification in notifications {
            print(notification.fireDate)
        }
        
//        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
}
