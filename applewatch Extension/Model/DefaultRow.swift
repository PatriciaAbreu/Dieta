
//
//  TableRowController.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 20/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import Foundation
import WatchKit

class DefaultRow:NSObject {
    static var processandoRequisicao = false
    
    @IBOutlet var lblTipo: WKInterfaceLabel!
    @IBOutlet var lblQuantidade: WKInterfaceLabel!
    @IBOutlet var lblPontos: WKInterfaceLabel!
    @IBOutlet var groupFundoBotao: WKInterfaceGroup!
    
    var tipo: String! {
        didSet {
            self.lblTipo.setText(self.tipo)
        }
    }
    var quantidade: String! {
        didSet {
            self.lblQuantidade.setText(self.quantidade)
        }
    }
    
    var pontos: Int! {
        didSet {
            self.lblPontos.setText(String(self.pontos))
        }
    }
    
    @IBAction func adicionarPontos() {
        if DefaultRow.processandoRequisicao { return }
        DefaultRow.processandoRequisicao = true
        
        WKInterfaceDevice.currentDevice().playHaptic(.Success)
        
        MainController.object.animateWithDuration(0.3) { () -> Void in
            self.groupFundoBotao.setBackgroundColor(UIColor(hexString: "#a0f04a"))
        }
        
        MainController.object.rowUltimoItemAdicionado = self
        DataSource.sharedInstance().adicionarPontos(self.tipo, quantidade: self.quantidade, pontos: self.pontos)
    }
}