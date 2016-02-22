//
//  InterfaceController.swift
//  applewatch Extension
//
//  Created by Rafael Moris on 20/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import WatchKit
import Foundation


class CategoriasController: WKInterfaceController  {
    // MARK: - IBOutlets
    @IBOutlet var table: WKInterfaceTable!
    
    //MARK: - Variaveis
    var dataSource:DataSource!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
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
        self.table.setNumberOfRows(self.dataSource.currentDataSource.count + 1, withRowType: "menuRow")
        
        for i in 0 ... self.dataSource.currentDataSource.count {
            let row:MenuRow = self.table.rowControllerAtIndex(i) as! MenuRow
            
            if i == 0 {
                row.lblTitulo.setText("Mostrar tudo")
            }else {
                let categoria = self.dataSource.currentDataSource[i - 1]
                row.lblTitulo.setText(categoria.nome)
            }
        }
        
        self.table.scrollToRowAtIndex(0)
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {

        WKInterfaceDevice.currentDevice().playHaptic(.Click)
        self.dataSource.currentType = .Categoria
        self.dataSource.filtrarPorCategoria(rowIndex)
        self.popController()
    }
}
