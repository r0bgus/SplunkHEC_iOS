//
//  Payload.swift
//  
//
//  Created by rg on 2/25/22.
//

import Foundation

struct SplunkHEC_Fields {
    var host:String = ""
    var source:String = ""
    var sourcetype:String = ""
    var index:String = ""
    var fields:[String:String] = [:]
}

class SplunkHEC_Payload {

    
    var host:String
    var source:String
    var sourcetype:String
    var index:String
    var fields:[String:String]
    
    var time:String
    var event:String
    
    var payload_dict:[String:Any] = [:]
    
    init(date:Date, event:String, fields:SplunkHEC_Fields = SplunkHEC_Fields()) {
        self.time = String(format:"%.3f",date.timeIntervalSince1970)
        payload_dict["time"] = self.time
        
        self.event = event
        payload_dict["event"] = self.event
        
        self.host = fields.host
        if self.host != "" {
            payload_dict["host"] = self.host
        }
        
        self.source = fields.source
        if self.source != "" {
            payload_dict["source"] = self.source
        }
        
        self.sourcetype = fields.sourcetype
        if self.sourcetype != "" {
            payload_dict["sourcetype"] = self.sourcetype
        }
        
        self.index = fields.index
        if self.index != "" {
            payload_dict["index"] = self.index
        }
        
        self.fields = fields.fields
        if self.fields.count > 0 {
            payload_dict["fields"] = self.fields
        }
        
    }
    
    func makePayloadString(endpoint:String) -> String? {
        
        switch(endpoint) {
            case "event":
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: payload_dict)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    return jsonString
                }
                catch {
                    print(NSError(domain:"SplunkHec:Payload cannot serialize into json.", code:41).localizedDescription)
                    return nil
                }
                
            case "raw":
                return self.event
                
            default:
                print(NSError(domain:"SplunkHec:Payload unknown endpoint string format.", code:51).localizedDescription)
                return nil
        }
        
    }
    
}


