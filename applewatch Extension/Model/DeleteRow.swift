
//
//  TableRowController.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 20/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import Foundation
import WatchKit

class DeleteRow:NSObject {
    @IBOutlet var lblTipo: WKInterfaceLabel!
    @IBOutlet var lblQuantidade: WKInterfaceLabel!
    @IBOutlet var lblPontos: WKInterfaceLabel!
    @IBOutlet var groupCelula: WKInterfaceGroup!
    @IBOutlet var groupFundoBotao: WKInterfaceGroup!
    
    var itemID:String!
    var identificador:String!
    
    static var processandoRequisicao = false
    
    @IBAction func removerPontos() {
        if DeleteRow.processandoRequisicao { return }
        DeleteRow.processandoRequisicao = true
        
        WKInterfaceDevice.currentDevice().playHaptic(.Failure)
        MainController.object.animateWithDuration(0.3) { () -> Void in
            self.groupFundoBotao.setBackgroundColor(UIColor(hexString: "#f04a4a"))
        }
        
        MainController.object.rowUltimoItemRemovido = self
        DataSource.sharedInstance().removerPontos(self.itemID, identificador: self.identificador)
    }
}