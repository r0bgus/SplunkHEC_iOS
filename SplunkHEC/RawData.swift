//
//  RawData.swift
//
//
//  Created by rg on 2/24/22.
//

import Foundation

public class SplunkHEC_RawData {
    
    private unowned let session:SplunkHEC_Session
    
    init(session:SplunkHEC_Session) {
        self.session = session
    }
    
    public func event(rawData:String,
                      date:Date = Date(),
                      fields:SplunkHEC_Fields? = nil
    ) {
        
        if session.is_active {
            session.add_event(date: date, event: rawData, fields: fields)
        }
        else {
            print(NSError(domain:"SplunkHec:RawData Session not set or started.", code:32).localizedDescription)
            
            return
        }
        
    }
    
}
