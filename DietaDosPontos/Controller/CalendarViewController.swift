//
//  MenuViewController.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 13/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import Foundation
import UIKit

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var dataSource:[HistoricoObject]!
    var controller:MainTableViewController!
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    static func loadFromNib()-> CalendarViewController {
        let nibName = "Calendar"
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiateWithOwner(self, options: nil).first as! CalendarViewController
    }
    
    override func viewDidLoad() {
        self.view.alpha = 0
        self.view.userInteractionEnabled = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.carregarDataSource()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.carregarDataSource()
        self.tableView.reloadData()
        
        self.view.frame = CGRect(x: Screen.width() * -0.5, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.alpha = 1.0
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
        
        let title = "Histórico"
        let params = ["Language": Device.language(), "Description": "Abriu menu do histórico"]
        Flurry.logEvent(title, withParameters: params)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = (touches.first?.locationInView(self.view))
        
        if location!.x > self.background.frame.width {
            self.fecharJanela()
        }
    }
    
    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count + 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            if self.dataSource.count > 0 {
                self.controller.mostrarItensDoDia(nil)
            }
        default:
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! CalendarCell
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-YYYY"
            let dataAtual = dateFormatter.stringFromDate(Lembrete.getCurrentLocalDate())
            
            let title = "Histórico Dia: \(dataAtual)"
            let params = ["Data Historico": cell.identifier, "Data Atual": dataAtual, "Language": Device.language(), "Description": "Filtro histórico baseado em uma data"]
            Flurry.logEvent(title, withParameters: params)

            self.controller.mostrarItensDoDia(cell.identifier)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return self.defaultCellAtIndexPath(indexPath)
    }
    
    func defaultCellAtIndexPath(indexPath:NSIndexPath)-> CalendarCell {
        let cell = MainTableViewController.mainTableView.dequeueReusableCellWithIdentifier("CalendarCell") as! CalendarCell
        
        switch indexPath.row {
        case 0:
            if self.dataSource.count == 0 {
                cell.lblData.text = "Nenhum registro"
            }else {
                cell.lblData.text = "Todas as datas"
            }
        default:
            let calendario = NSCalendar.currentCalendar()
            calendario.timeZone = NSTimeZone(abbreviation: "GMT")!
            
            let historico = self.dataSource[indexPath.row - 1]
            let data = historico.date!
            
            let day = calendario.component(NSCalendarUnit.Day, fromDate: data)
            let month = calendario.component(NSCalendarUnit.Month, fromDate: data)
            let year = calendario.component(NSCalendarUnit.Year, fromDate: data)
                
            let texto = "\(day)/\(month)/\(year)"
            cell.lblData.text = texto
            cell.identifier = "\(day)-\(month)-\(year)"
        }
        
        return cell
    }
    
    func carregarDataSource() {
        if self.dataSource == nil {
            self.dataSource = [HistoricoObject]()
        }
        self.dataSource.removeAll()
        
        let database = RealmManager.sharedInstance()
        var historicos = database.objectsOfType(HistoricoObject.self)!
        
        historicos = historicos.sorted("date", ascending: false)
        
        for historico in historicos {
            self.dataSource.append(historico as HistoricoObject)
        }
    }
    @IBAction func voltar(sender: AnyObject) {
        self.fecharJanela()
    }
    
    func fecharJanela() {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.alpha = 0.0
            self.view.frame = CGRect(x: Screen.width() * -0.5, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
        
        delay(1.0, closure: { () -> () in
            self.dismissViewControllerAnimated(false, completion: nil)
        })
    }
}