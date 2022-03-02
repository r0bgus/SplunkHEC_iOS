//
//  Session.swift
//  
//
//  Created by rg on 2/8/22.
//

import Foundation

class SplunkHEC_Session {
    
    let session_id:String
    var is_active:Bool = false
    private let splunkHEC_Batch:SplunkHEC_Batch
    private var splunkHEC_Configs:SplunkHEC_Configs!
    private var splunkHEC_Request:SplunkHEC_Request
    private let endpoint:String
    private let static_fields:SplunkHEC_Fields!
    
    let Log:SplunkHEC_Log
    
    init(splunkHEC_Configs:SplunkHEC_Configs, splunkHEC_Request: SplunkHEC_Request) {
        self.splunkHEC_Configs = splunkHEC_Configs
        self.splunkHEC_Request = splunkHEC_Request
        endpoint = splunkHEC_Configs.endpoint
        splunkHEC_Batch = SplunkHEC_Batch(splunkHEC_Batch_Configs:self.splunkHEC_Configs.splunkHEC_Batch_Configs)
        session_id = UUID().uuidString

        static_fields = self.splunkHEC_Configs.static_fields
        
        Log = SplunkHEC_Log(string_format: self.splunkHEC_Configs.log_format)
        Log.set_session(session: self)
        
    }
    
    func start_session() {
        
        is_active = true
    }
    
    func stop_session() {
        is_active = false
        flush_events()
    }
    
    private func flush_events() {
        let events = splunkHEC_Batch.flush()
        send_events(events:events)
    }
    
    func send_events(events:[String]) {
        let string_payload = events.joined(separator: "\n")
        splunkHEC_Request.hec_send_events(endpoint: endpoint, data: string_payload) { (success,error) in
            if success {
                
            }
            else {
                print(error!.localizedDescription)
            }
        }
    }
    
    func add_event(date:Date,event:String) {
        //convert date and event to hec payload
        let hec_payload:SplunkHEC_Payload = SplunkHEC_Payload(date: date, event: event, fields: static_fields)
        
        guard let hec_payload_string = hec_payload.makePayloadString(endpoint: splunkHEC_Configs.endpoint) else {
            return
        }
                
        let flushable_contents = splunkHEC_Batch.append(payload_string: hec_payload_string)
        if flushable_contents.count > 0 {
            send_events(events:flushable_contents)
        }
    }
    
}
