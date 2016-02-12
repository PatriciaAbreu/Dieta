//
//  Lembrete.swift
//  DietaDosPontos
//
//  Created by Patricia Machado de Abreu on 2/12/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import UIKit

class Lembrete {
    
    
    func criarNotificacao() {
        let notification = UILocalNotification()

        notification.alertBody = "Não se esqueça de marcar teu almoço!"
        let calendario = NSCalendar.currentCalendar()
        var dataAtual = NSDate()
        dataAtual = calendario.dateBySettingHour(6, minute: 27, second: 0, ofDate: dataAtual, options: NSCalendarOptions(rawValue: 0))!
        print(dataAtual)
        dataAtual.dateByAddingTimeInterval(NSTimeInterval(60 * 2))
        
        notification.fireDate = NSDate(timeInterval: NSTimeInterval(60*2), sinceDate: dataAtual)
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        print(dataAtual)
        
            }
        }




    
//    // Notificação
//    
//    func notif() -> UILocalNotification{
//        var localNotification:UILocalNotification = UILocalNotification()
//        localNotification.alertAction = "Comer!"
//        let calendario = NSCalendar.currentCalendar()
//        var dataAual = NSDate()
//        
//        for dia in 0 ..< 7 {
//            dataAual.dateByAddingTimeInterval(NSTimeInterval(60 * 60 * 24 * dia))
//            for var hora = 6; hora <= 21; hora += 3 {
//                dataAual = calendario.dateBySettingHour(hora, minute: 0, second: 0, ofDate: dataAual, options: NSCalendarOptions(rawValue: 0))!
//                
//                switch hora {
//                case 6:
//                    localNotification.alertBody = "Não se esqueça de marcar aqui seu café da manhã!"
//                case 9:
//                    localNotification.alertBody = "Não se esqueça do seu lanche!"
//                case 12:
//                    localNotification.alertBody = "Já almoçou? E já marcou seu almoço aqui?"
//                case 15:
//                    localNotification.alertBody = "Não se esqueça do seu lanche!"
//                case 18:
//                    localNotification.alertBody = "Não se esqueça do seu lanche!"
//                case 21:
//                    localNotification.alertBody = "Já jantou? E já marcou ele aqui?"
//                break;
//                }
//                localNotification.soundName = UILocalNotificationDefaultSoundName
//                localNotification.applicationIconBadgeNumber = 1
//                
//                localNotification.fireDate = NSDate(timeInterval: hora, sinceDate: dataAtual)
//                return localNotification
//            }
//        }
//        
//        if diasRestantes == 0 {
//            localNotification.alertBody = "Vish, a '\(strNotif)' é hoje!"
//        }
//        else if diasRestantes == 1 {
//            localNotification.alertBody = "Vish, falta \(diasRestantes) dia para a '\(strNotif)'!"
//        }
//        else {
//            localNotification.alertBody = "Vish, faltam \(diasRestantes) dias para a '\(strNotif)'!"
//        }
//        
//        let dateFix: NSTimeInterval = floor(at.data.timeIntervalSinceReferenceDate / 60.0) * 60.0
//        var horario: NSDate = NSDate(timeIntervalSinceReferenceDate: dateFix)
//        
//        let intervalo: NSTimeInterval = -NSTimeInterval(60*60*24 * (diasRestantes))
//        
//        localNotification.soundName = UILocalNotificationDefaultSoundName
//        localNotification.applicationIconBadgeNumber = 1
//        
//        localNotification.fireDate = NSDate(timeInterval: intervalo, sinceDate: horario)
//        return localNotification
//    }
//    
//    func criarNotificacao(at: Atividade) {
//        for i in 0..<7 {
//            UIApplication.sharedApplication().scheduleLocalNotification(notif(at, i: i))
//        }
////}
//}
