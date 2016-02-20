//
//  Lembrete.swift
//  DietaDosPontos
//
//  Created by Patricia Machado de Abreu on 2/12/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import UIKit

class Lembrete {
    private static var lembretesAgendados:[String]!
    private static func containNotification(identifier:String)-> Bool{
        if self.lembretesAgendados == nil {
            self.lembretesAgendados = [String]()
            let notifications = UIApplication.sharedApplication().scheduledLocalNotifications!
            for notification in notifications {
                let identifier = String(notification.fireDate!.timeIntervalSince1970)
                self.lembretesAgendados!.append(identifier)
            }
        }
        
        return self.lembretesAgendados.contains(identifier)
    }
    var notification:UILocalNotification!
    
    static func gerarLembretesParaXDias(x dias:Int) {
        let calendario = NSCalendar.currentCalendar()
        calendario.timeZone = NSTimeZone(abbreviation: "GMT")!
        
        for dia in 0 ..< dias {
            var dataAtual = self.getCurrentLocalDate()
            dataAtual = dataAtual.dateByAddingTimeInterval(NSTimeInterval(60 * 60 * 24 * dia))
            
            for var hora = 7; hora <= 19; hora += 3 {
                dataAtual = calendario.dateBySettingHour(hora, minute: 0, second: 0, ofDate: dataAtual, options: NSCalendarOptions(rawValue: 0))!
                
                let identifier = String(dataAtual.timeIntervalSince1970)
                if self.containNotification(identifier) {
                    continue
                }
                
                let lembrete = Lembrete()
                lembrete.notification = UILocalNotification()
                lembrete.notification.timeZone = calendario.timeZone
                lembrete.notification.soundName = UILocalNotificationDefaultSoundName
                
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
//        self.printNotifications()
    }
    
    static func printNotifications() {
        print("Scheduled Local Notifications")
        let notifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        for notification in notifications {
            print("scheduled: ", notification.fireDate!)
        }
        
//        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    static func getCurrentLocalDate()-> NSDate {
        var now = NSDate()
        let nowComponents = NSDateComponents()
        let calendar = NSCalendar.currentCalendar()
        
        nowComponents.year = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: now)
        nowComponents.month = NSCalendar.currentCalendar().component(NSCalendarUnit.Month, fromDate: now)
        nowComponents.day = NSCalendar.currentCalendar().component(NSCalendarUnit.Day, fromDate: now)
        nowComponents.hour = NSCalendar.currentCalendar().component(NSCalendarUnit.Hour, fromDate: now)
        nowComponents.minute = NSCalendar.currentCalendar().component(NSCalendarUnit.Minute, fromDate: now)
        nowComponents.second = NSCalendar.currentCalendar().component(NSCalendarUnit.Second, fromDate: now)
        
        nowComponents.timeZone = NSTimeZone(abbreviation: "GMT")
        
        now = calendar.dateFromComponents(nowComponents)!
        
        return now
    }
}
