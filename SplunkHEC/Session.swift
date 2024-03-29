//
//  Session.swift
//  
//
//  Created by rg on 2/8/22.
//

import Foundation

public class SplunkHEC_Session {
    
    public let session_id:String
    public var is_active:Bool = false
    public let Log:SplunkHEC_Log
    
    private let splunkHEC_Batch:SplunkHEC_Batch
    private var splunkHEC_Configs:SplunkHEC_Configs!
    private var splunkHEC_Request:SplunkHEC_Request
    
    private let endpoint:String
    private let static_fields:SplunkHEC_Fields!
    
    private var batchTimer = Timer()
    
    
    init(splunkHEC_Configs:SplunkHEC_Configs, splunkHEC_Request: SplunkHEC_Request) {
        self.splunkHEC_Configs = splunkHEC_Configs
        self.splunkHEC_Request = splunkHEC_Request
        endpoint = splunkHEC_Configs.endpoint
        splunkHEC_Batch = SplunkHEC_Batch(splunkHEC_Batch_Configs:self.splunkHEC_Configs.splunkHEC_Batch_Configs)
        session_id = UUID().uuidString

        static_fields = self.splunkHEC_Configs.static_fields
        
        Log = SplunkHEC_Log(string_format: self.splunkHEC_Configs.log_format, time_format: self.splunkHEC_Configs.time_format)
        Log.set_session(session: self)
        
    }
    
    func start_session() {
        is_active = true
        
        let interval = Double(splunkHEC_Configs.splunkHEC_Batch_Configs.milliSeconds_Buffer)/1000.0
        
        DispatchQueue.global(qos: .background).async {
            self.batchTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block:
            { [weak self] _ in
                self?.flush_events(from:"timer")
            })
            let runLoop = RunLoop.current
            runLoop.add(self.batchTimer, forMode: RunLoop.Mode.default)
            runLoop.run()
        }
        
        
        //RunLoop.main.add(batchTimer, forMode: .common)
    }
    
    func stop_session() {
        is_active = false
        batchTimer.invalidate()
        flush_events()
    }
    
    private func flush_events(from:String="") {
        let events = splunkHEC_Batch.flush()
        if events.count > 0 {
            send_events(events:events)
        }
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
