//
//  MenuViewController.swift
//  DietaDosPontos
//
//  Created by Rafael Moris on 13/02/16.
//  Copyright © 2016 Rafael Moris. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var controller:MainTableViewController!
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    static func loadFromNib()-> MenuViewController {
        let nibName = "Menu"
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiateWithOwner(self, options: nil).first as! MenuViewController
    }
    
    override func viewDidLoad() {
        self.view.alpha = 0
        self.view.userInteractionEnabled = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        self.view.frame = CGRect(x: Screen.width() * 0.5, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.alpha = 1.0
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = (touches.first?.locationInView(self.view))
        
        if location!.x < self.background.frame.origin.x {
            UIView.animateWithDuration(0.3) { () -> Void in
                self.view.alpha = 0.0
                self.view.frame = CGRect(x: Screen.width() * 0.5, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            }
            
            delay(1.0, closure: { () -> () in
                self.dismissViewControllerAnimated(false, completion: nil)
            })
        }
    }
    
    // MARK: - TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.controller.dataSource.count + 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.controller.categoriaSelecionada = nil
        default:
            self.controller.categoriaSelecionada = self.controller.dataSource[indexPath.row - 1].nome
        }
        
        self.controller.mostrarItensDaCategoriaSelecionada()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return self.defaultCellAtIndexPath(indexPath)
    }
    
    func defaultCellAtIndexPath(indexPath:NSIndexPath)-> CategoryCell {
        let cell = MainTableViewController.mainTableView.dequeueReusableCellWithIdentifier("CategoryCell") as! CategoryCell
        
        switch indexPath.row {
        case 0:
            cell.lblCategoria.text = "Todas as categorias"
        default:
            cell.definirValoresBaseadoNoItem(self.controller.dataSource[indexPath.row - 1])
        }
        
        return cell
    }
}