//
//  RealmManager.swift
//  Crypto
//
//  Created by Rafael Moris on 28/10/15.
//  Copyright © 2015 Fanatee. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    var database:Realm?
    
    class func sharedInstance()->RealmManager {
        struct Static {
            static let instance:RealmManager = RealmManager(sharedInstance: true)
        }
        
        return Static.instance
    }
    
    init(sharedInstance: Bool) {
        var configuration = Realm.Configuration.defaultConfiguration
        configuration.schemaVersion = 0
        configuration.migrationBlock = { (migration:Migration, oldSchemaVersion:UInt64) ->  Void in
//            migration.enumerate(Player.className()) { oldObject, newObject in
//                if (oldSchemaVersion < 1) {
//                    newObject!["exemploNovoCampo"] = ""
//                }
//            }
        }
        
        Realm.Configuration.defaultConfiguration = configuration;
        self.database = try! Realm()
        print("Schema Version: \(database!.configuration.schemaVersion)")
        print("Database Path: \(database!.path)")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    func add(object:Object) {
//        try! self.database!.write {
            self.database!.add(object)
//        }
    }
    
    func delete(object:Object) {
        try! self.database!.write {
            self.database!.delete(object)
        }
    }
    
    func deleteAllObjctesWithType<T: Object>(type: T.Type, andIdentifier identifier:String) {
        let predicate = NSPredicate(format: "identifier = %@", identifier)
        let objects = self.database!.objects(type).filter(predicate)
        
        try! self.database!.write {
            self.database!.delete(objects)
        }
    }
    
    func hasObjectOfType<T: Object>(type: T.Type)-> Bool {
        return self.database!.objects(type).count > 0
    }
    
    func hasObjectOfType<T: Object>(type: T.Type, withIdentifier identifier: String)-> Bool {
        
        let predicate = NSPredicate(format: "identifier = %@", identifier)
        let objects = self.database!.objects(type).filter(predicate)
        
        return objects.count > 0
    }
    
    func firstObjectOfType<T: Object>(type: T.Type)->T? {
        return self.database!.objects(type).first
    }
    
    func firstObjectOfType<T: Object>(type: T.Type , withIdentifier identifier: String)->T? {
        
        let predicate = NSPredicate(format: "identifier = %@", identifier)
        return self.database!.objects(type).filter(predicate).first
    }
    
    func objectsOfType<T: Object>(type: T.Type , withIdentifier identifier: String? = nil)->Results<T>? {
        
        if identifier != nil {
            let predicate = NSPredicate(format: "identifier = %@", identifier!)
            return self.database!.objects(type).filter(predicate)
        }else {
            return self.database!.objects(type)
        }
    }
    
    func objectsOfType<T: Object>(type: T.Type, identifier:String, value:String)->Results<T>? {
        
        let predicate = NSPredicate(format: "\(identifier) = %@", value)
        return self.database!.objects(type).filter(predicate)
    }
    
    func beginWrite() {
        self.database?.beginWrite()
    }
    
    func commitWrite() {
        try! self.database?.commitWrite()
    }
}