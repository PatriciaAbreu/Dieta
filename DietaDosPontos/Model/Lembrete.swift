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
                    lembrete.notification.alertBody = "Comece o dia bem, comece marcando seus pontos!"
                case 10:
                    lembrete.notification.alertBody = "Se resolveu reforçar o café da manhã, marque esses pontos também."
                case 13:
                    lembrete.notification.alertBody = "Hora do almoço, como será que estão seus pontos?"
                case 16:
                    lembrete.notification.alertBody = "Parou para um lanche? Aproveite para marcar seus pontos."
                case 19:
                    lembrete.notification.alertBody = "Chegando o final do dia, hora de ver sua pontuação."
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
