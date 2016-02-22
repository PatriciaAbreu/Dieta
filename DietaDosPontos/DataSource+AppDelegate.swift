import UIKit
import WatchConnectivity

extension AppDelegate: WCSessionDelegate {
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        
        if let action = message["action"] as? String {
            switch action {
            case "carregarHistoricos":
                var identificador = message["identificador"] as? String
                if identificador == "" {
                    identificador = nil
                }
                replyHandler(["historicos": self.gerarHistoricos(identificador)])
            case "adicionarPontos":
                var identificador = message["identificador"] as? String
                if identificador == "" {
                    identificador = nil
                }
                
                let tipo = message["tipo"] as! String
                let quantidade = message["quantidade"] as! String
                let pontos = message["pontos"] as! Int
                
                self.adicionarPontos(tipo, quantidade: quantidade, pontos: pontos)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    replyHandler(["success": true, "historicos": self.gerarHistoricos(identificador)])
                    
                    })
            case "removerPontos":
                var identificador = message["identificador"] as? String
                if identificador == "" {
                    identificador = nil
                }
                
                let itemID = message["itemID"] as! String
                self.removerPontos(itemID)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    replyHandler(["success": true, "historicos": self.gerarHistoricos(identificador)])
                    
                })
            default:
                break
            }
        }
    }
    
    func gerarHistoricos(identificador:String?)->String {
        var json = "["
        
        let database = RealmManager(sharedInstance: false)
        
        let calendario = NSCalendar.currentCalendar()
        calendario.timeZone = NSTimeZone(abbreviation: "GMT")!
        
        var historicos = database.objectsOfType(HistoricoObject.self)!
        if identificador != nil {
            historicos = database.objectsOfType(HistoricoObject.self, withIdentifier: identificador!)!
        }
        
        historicos = historicos.sorted("date", ascending: false)
        
        var i = 0
        for historico in historicos {
            if i == 0 {
                json += "{"
            }else {
                json += ",{"
            }
            i++
            
            let data = historico.date!
            
            let day = calendario.component(NSCalendarUnit.Day, fromDate: data)
            let month = calendario.component(NSCalendarUnit.Month, fromDate: data)
            let year = calendario.component(NSCalendarUnit.Year, fromDate: data)
            
            let nome = "\(day)/\(month)/\(year)"
            
            var itensObject = database.objectsOfType(ItemObject.self, withIdentifier: historico.identifier)!
            
            var total = 0
            
            itensObject = itensObject.sorted("date", ascending: true)
            
            json += "\"titulo\":\"" + nome + "\""
            json += ",\"identifier\":\"" + historico.identifier + "\""
            json += ",\"itens\":["
            var j = 0
            for itemObject in itensObject {
                if j == 0 {
                    json += "{"
                }else {
                    json += ",{"
                }
                j++
                
                json += "\"identifier\":\"" + itemObject.identifier + "\""
                json += ",\"itemID\":\"" + itemObject.itemID + "\""
                json += ",\"tipo\":\"" + itemObject.tipo + "\""
                json += ",\"quantidade\":\"" + itemObject.quantidade + "\""
                json += ",\"pontos\":" + String(itemObject.pontos)
                
                json += "}"
                
                total += itemObject.pontos
            }
            json += "]"
            
            json += ",\"totalDePontos\":" + String(total)
            
            json += "}"
        }
        
        json += "]"
        
        return json
    }
    
    func adicionarPontos(tipo:String, quantidade:String, pontos: Int) {
        let database = RealmManager(sharedInstance: false)
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
        
        item.tipo = tipo
        item.quantidade = quantidade
        item.pontos = pontos
        
        database.add(item)
        
        database.commitWrite()
        
        let title = "Adicionou (watch): \(tipo)"
        let params = ["Language": Device.language(), "Description": "Usuário apagou um item do histórico"]
        Flurry.logEvent(title, withParameters: params)
    }
    
    func removerPontos(itemID:String)->Bool {
        var apagarSessao = false
        
        let database = RealmManager(sharedInstance: false)
        
        let itens = database.objectsOfType(ItemObject.self, identifier: "itemID", value: itemID)
        if let item = itens?.first {
            let title = "Apagou (watch): \(item.tipo)"
            let params = ["Language": Device.language(), "Description": "Usuário apagou um item do histórico"]
            Flurry.logEvent(title, withParameters: params)
            
            let identifier = item.identifier
            database.delete(item)
            
            if database.hasObjectOfType(ItemObject.self, withIdentifier:identifier) == false {
                let historicos = database.objectsOfType(HistoricoObject.self, withIdentifier: identifier)
                if let historico = historicos?.first {
                    database.delete(historico)
                    apagarSessao = true
                }
            }
        }
        
        return apagarSessao
    }
    
    func atualizarComplecation() {
        let calendario = NSCalendar.currentCalendar()
        calendario.timeZone = NSTimeZone(abbreviation: "GMT")!
        let dataAtual = Lembrete.getCurrentLocalDate()
        
        let day = calendario.component(NSCalendarUnit.Day, fromDate: dataAtual)
        let month = calendario.component(NSCalendarUnit.Month, fromDate: dataAtual)
        let year = calendario.component(NSCalendarUnit.Year, fromDate: dataAtual)
        
        let identificador = "\(day)-\(month)-\(year)"
        
        let database = RealmManager(sharedInstance: false)
        
        var historicos = database.objectsOfType(HistoricoObject.self, withIdentifier: identificador)!
        historicos = historicos.sorted("date", ascending: false)
        
        var total = 0
        
        for historico in historicos {
            var itensObject = database.objectsOfType(ItemObject.self, withIdentifier: historico.identifier)!
            
            itensObject = itensObject.sorted("date", ascending: true)
            
            for itemObject in itensObject {
                total += itemObject.pontos
            }
        }
        
        self.session?.transferCurrentComplicationUserInfo(["identificador": identificador, "pontosDeHoje": String(total), "historicos": self.gerarHistoricos(nil)])
    }
}

