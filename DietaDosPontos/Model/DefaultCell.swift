//
//  DefaultCell.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 11/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import Foundation
import UIKit

class DefaultCell: UITableViewCell {
    var controller:MainTableViewController!
    
    @IBOutlet weak var btnAdicionar: AddButton!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblQuantidade: UILabel!
    @IBOutlet weak var lblPontos: UILabel!
    
    func definirValoresBaseadoNoItem(item:Item, section:Int, row:Int) {
        self.lblTipo.text = item.tipo
        self.lblQuantidade.text = item.quantidade
        self.lblPontos.text = String(item.pontos)
        self.btnAdicionar.section = section
        self.btnAdicionar.row = row
    }
    
    @IBAction func adicionarPontos(sender: AnyObject) {
        let button = sender as! AddButton
        let section = button.section
        let row = button.row

        let database = RealmManager.sharedInstance()
        database.beginWrite()
        
        let calendario = NSCalendar.currentCalendar()
        calendario.timeZone = NSTimeZone(abbreviation: "GMT")!
        let dataAtual = Lembrete.getCurrentLocalDate()
        
        let day = calendario.component(NSCalendarUnit.Day, fromDate: dataAtual)
        let month = calendario.component(NSCalendarUnit.Month, fromDate: dataAtual)
        let year = calendario.component(NSCalendarUnit.Year, fromDate: dataAtual)
        
        let identifier = "\(day)-\(month)-\(year)"
        
        var currentHistorico:HistoricoObject!
        let historicos = database.objectsOfType(HistoricoObject.self, withIdentifier: identifier)!
        if historicos.count > 0 {
            currentHistorico = historicos.first!
        }else {
            let historico = HistoricoObject()
            historico.identifier = identifier
            historico.date = dataAtual
            
            database.add(historico)
            
            currentHistorico = historico
        }
        
        let item = ItemObject()
        item.identifier = currentHistorico.identifier
        item.itemID = NSUUID().UUIDString
        item.date = dataAtual
        item.tipo = self.controller.dadosFiltrados[section][row].tipo
        item.quantidade = self.controller.dadosFiltrados[section][row].quantidade
        item.pontos = self.controller.dadosFiltrados[section][row].pontos
        
        database.add(item)
        
        database.commitWrite()
        
        self.controller.feedbackAdd(button)
    }
}