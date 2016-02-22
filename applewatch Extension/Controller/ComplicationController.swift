//
//  ComplicationController.swift
//  applewatch Extension
//
//  Created by Rafael Moris on 20/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import ClockKit
import WatchKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    static var pontos = "0"
    var complications: [CLKComplication]!
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirectionsForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.Forward, .Backward])
    }
    
    func getTimelineStartDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDateForComplication(complication: CLKComplication, withHandler handler: (NSDate?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehaviorForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.ShowOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntryForComplication(complication: CLKComplication, withHandler handler: ((CLKComplicationTimelineEntry?) -> Void)) {

        let defaults:NSUserDefaults = NSUserDefaults(suiteName: "group.com.paty.rafa.vidaecontrole")!
        var pontos = "0"
        if let ultimosPontos = defaults.stringForKey("pontosDeHoje") {
            let calendario = NSCalendar.currentCalendar()
            calendario.timeZone = NSTimeZone(abbreviation: "GMT")!
            let dataAtual = ComplicationController.getCurrentLocalDate()
            
            let day = calendario.component(NSCalendarUnit.Day, fromDate: dataAtual)
            let month = calendario.component(NSCalendarUnit.Month, fromDate: dataAtual)
            let year = calendario.component(NSCalendarUnit.Year, fromDate: dataAtual)
            
            let identificador = "\(day)-\(month)-\(year)"
            
            if identificador == defaults.stringForKey("identificador") {
                pontos = ultimosPontos
            }
        }
        
        var entry:CLKComplicationTimelineEntry? = nil
        let now = ComplicationController.getCurrentLocalDate()
        
        switch complication.family {
        case .CircularSmall:
            let template = CLKComplicationTemplateCircularSmallStackImage()
            
            template.line2TextProvider = CLKSimpleTextProvider(text: "\(pontos) pontos", shortText: pontos)
            
            template.line1ImageProvider = CLKImageProvider(onePieceImage: UIImage(named: "logo")!)
            template.tintColor = UIColor(hexString: "#a34af0")
            
            // Create the entry.
            entry = CLKComplicationTimelineEntry(date: now, complicationTemplate: template)
            
        case .ModularLarge:
            let template = CLKComplicationTemplateModularLargeStandardBody()
            
            template.headerTextProvider = CLKSimpleTextProvider(text: "Vida e Controle", shortText: "Vida e Controle")
            template.headerImageProvider = CLKImageProvider(onePieceImage: UIImage(named: "logo")!)
            template.body1TextProvider = CLKSimpleTextProvider(text: "\(pontos) pontos", shortText: pontos)
            
            template.tintColor = UIColor(hexString: "#a34af0")
            
            // Create the entry.
            entry = CLKComplicationTimelineEntry(date: now, complicationTemplate: template)
        case .ModularSmall:
            let template = CLKComplicationTemplateModularSmallStackImage()
            
            template.line2TextProvider = CLKSimpleTextProvider(text: "\(pontos) pontos", shortText: pontos)
            
            template.line1ImageProvider = CLKImageProvider(onePieceImage: UIImage(named: "logo")!)
            template.tintColor = UIColor(hexString: "#a34af0")
            
            // Create the entry.
            entry = CLKComplicationTimelineEntry(date: now, complicationTemplate: template)
            
        case .UtilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            
            template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "logo")!)
            template.textProvider = CLKSimpleTextProvider(text: "\(pontos) pontos", shortText: pontos)
            
            template.tintColor = UIColor(hexString: "#a34af0")
            
            // Create the entry.
            entry = CLKComplicationTimelineEntry(date: now, complicationTemplate: template)
        case .UtilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            
            template.textProvider = CLKSimpleTextProvider(text: "\(pontos) pontos", shortText: pontos)
            
            template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "logo")!)
            template.tintColor = UIColor(hexString: "#a34af0")
            
            // Create the entry.
            entry = CLKComplicationTimelineEntry(date: now, complicationTemplate: template)
        }
        
        

        handler(entry)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, beforeDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntriesForComplication(complication: CLKComplication, afterDate date: NSDate, limit: Int, withHandler handler: (([CLKComplicationTimelineEntry]?) -> Void)) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Update Scheduling
    
    func getNextRequestedUpdateDateWithHandler(handler: (NSDate?) -> Void) {
        // Call the handler with the date when you would next like to be given the opportunity to update your complication content
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getPlaceholderTemplateForComplication(complication: CLKComplication, withHandler handler: (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        handler(nil)
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
