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
        var dataAtual = NSDate()
        
        for dia in 0 ..< dias {
            dataAtual.dateByAddingTimeInterval(NSTimeInterval(60 * 60 * 24 * dia))
            for var hora = 6; hora <= 21; hora += 3 {
                dataAtual = calendario.dateBySettingHour(hora, minute: 0, second: 0, ofDate: dataAtual, options: NSCalendarOptions(rawValue: 0))!
                
                let lembrete = Lembrete()
                lembrete.notification = UILocalNotification()
                lembrete.notification.timeZone = NSTimeZone.defaultTimeZone()
                
                switch hora {
                case 6:
                    lembrete.notification.alertBody = "Algo as 6"
                case 9:
                    lembrete.notification.alertBody = "Algo as 9"
                case 12:
                    lembrete.notification.alertBody = "Algo as 12"
                case 15:
                    lembrete.notification.alertBody = "Algo as 15"
                case 18:
                    lembrete.notification.alertBody = "Algo as 18"
                case 21:
                    lembrete.notification.alertBody = "Algo as 21"
                default:
                    break;
                }
                
                lembrete.notification.fireDate = dataAtual
                UIApplication.sharedApplication().scheduleLocalNotification(lembrete.notification)
            }
        }
    }
}
