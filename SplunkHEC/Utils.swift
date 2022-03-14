//
//  Utils.swift
//  
//
//  Created by rg on 2/8/22.
//

import Foundation

struct SplunkHEC_Utils {

    
    func dict2KV(dict:[String:Any]) -> String {
        
        var KVs:[String] = []
        _dict2KV(dict:dict) { kv in
            KVs.append(kv)
        }
        return KVs.joined(separator: " ")
        
    }
    
    func _dict2KV(dict:[String:Any],key_crumbs:[String]=[], completion:(String) -> Void) {
            
        for (key,value):(String,Any) in dict {
            
            var key_crumb = key_crumbs
            key_crumb.append(key)
            if let innerDict = dict[key] as? [String:Any] {
                _dict2KV(dict: innerDict, key_crumbs: key_crumb, completion: completion)
            }
            else {
                var escaped_value = String(describing: value)
                
                escaped_value = escaped_value.replacingOccurrences(of: "\"", with: #"\""#)
                completion("\(key_crumb.joined(separator: ":"))=\"\(escaped_value)\"")
            }
            
        }
        
    }
    
    func formatDate(date:Date,format:String="yyyy-MM-dd HH:mm:ss.SSS") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.string(from: date)
    }
    
    func formatLogString(logEvent:[String:String],format:String) -> String {
        
        var log_event = format
        
        for (key,value):(String,String) in logEvent {
            log_event = log_event.replacingOccurrences(of: "%"+key+"%", with: value)
        }
        
        return log_event
    }
    
}
