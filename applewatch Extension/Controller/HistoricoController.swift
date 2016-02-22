//
//  InterfaceController.swift
//  applewatch Extension
//
//  Created by Rafael Moris on 20/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import WatchKit
import Foundation

class HistoricoController: WKInterfaceController  {
    static var aguardandoDados = false
    static var object:HistoricoController!
    
    // MARK: - IBOutlets
    @IBOutlet var table: WKInterfaceTable!
    @IBOutlet var lblVazio: WKInterfaceLabel!
    
    //MARK: - Variaveis
    var dataSource:DataSource!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        HistoricoController.object = self
        self.dataSource = DataSource.sharedInstance()
        self.reloadData()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    //MARK: - Tabela
    func reloadData() {
        if self.dataSource.currentDataSourceHistorico != nil {
            if self.dataSource.currentDataSourceHistorico.count == 0 {
                self.lblVazio.setText("Nenhum registro")
                self.lblVazio.setHidden(false)
            }else {
                self.lblVazio.setHidden(true)
                self.table.setNumberOfRows(self.dataSource.currentDataSourceHistorico.count, withRowType: "menuRow")
                
                for i in 0 ..< self.dataSource.currentDataSourceHistorico.count {
                    let row:MenuRow = self.table.rowControllerAtIndex(i) as! MenuRow
                    
                    let historico = self.dataSource.currentDataSourceHistorico[i]
                    row.lblTitulo.setText(historico.titulo)
                }
            }
            self.table.scrollToRowAtIndex(0)
        }else {
            HistoricoController.aguardandoDados = true
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        
        WKInterfaceDevice.currentDevice().playHaptic(.Click)
        self.dataSource.currentType = .Historico
        self.dataSource.filtrarPorHistorico(rowIndex)
        self.dataSource.contemModificacoes = true
        self.popController()
    }
}
