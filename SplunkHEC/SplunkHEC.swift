//
//  SplunkHec.swift
//
//  Created by rg on 2/7/22.
//

import Foundation

public struct SplunkHEC_Configs {
    
    public var hec_token:String
    public var splunk_URL:String
    public var enforce_SSL:Bool!
    public var endpoint:String!
    //log format
    /*
     %timestamp%
     %session_id%
     %level%
     %file%
     %line_number%
     %function%
     %message%
     */
    public var log_format:String!
    public var time_format:String!  //how time is displayed for %timestamp%. Note: when using hec event endpoint, a seperate timestamp is passed for indexing, making this timestamp purely cosmetic. When using the raw endpoint, the timestamp is used for line breaking and parsing.
    
    //batch configs
    public var splunkHEC_Batch_Configs:SplunkHEC_Batch_Configs!
    
    //static fields
    public var static_fields:SplunkHEC_Fields!
    
    public init(hec_token:String,
                splunk_URL:String,
                endpoint:String = "event",
                enforce_SSL:Bool = true,
                log_format:String = "",
                time_format:String = "",
                static_fields:SplunkHEC_Fields = SplunkHEC_Fields(),
                splunkHEC_Batch_Configs:SplunkHEC_Batch_Configs = SplunkHEC_Batch_Configs()
    
    ) {
        let splunkHEC_GlobalSettings = SplunkHEC_GlobalSettings()
        
        self.hec_token = hec_token
        self.splunk_URL = splunk_URL
        self.endpoint = endpoint
        self.enforce_SSL = enforce_SSL
        if log_format == "" { self.log_format = splunkHEC_GlobalSettings.log_format } else {self.log_format = log_format }
        if time_format == "" { self.time_format = splunkHEC_GlobalSettings.time_format } else {self.time_format = time_format }
        self.static_fields = static_fields
        self.splunkHEC_Batch_Configs = splunkHEC_Batch_Configs
        
    }
    
    
}

struct SplunkHEC_GlobalSettings {
    let available_endpoints:[String:String] = ["event":"/services/collector/event",
                                               "raw":"/services/collector/raw",
                                               "health":"/services/collector/health"]
    let log_format:String = "%timestamp% - %session_id% - [%level%][%file%:%line%][%function%] - %message%"
    let time_format:String = "yyyy-MM-dd HH:mm:ss.SSS"
    
}

public final class SplunkHEC {
    
    
    
    private var splunkHEC_Configs:SplunkHEC_Configs!
    private var splunkHEC_Request:SplunkHEC_Request!
    private var current_splunkHEC_Session:SplunkHEC_Session!
    
    public var is_init:Bool = false
    
    public init?(hec_token:String,
          splunk_URL:String,
          endpoint:String = "event") {
        
        
        if !validate_init(splunk_URL: splunk_URL, endpoint: endpoint) {
            return nil
        }
        
        splunkHEC_Configs = SplunkHEC_Configs(hec_token: hec_token, splunk_URL: splunk_URL, endpoint:endpoint)
        splunkHEC_Request = SplunkHEC_Request(splunkHEC_Configs:splunkHEC_Configs)
        
        
    }
    
    public init?(splunkHEC_Configs: SplunkHEC_Configs) {
        
        
        if !validate_init(splunk_URL: splunkHEC_Configs.splunk_URL, endpoint: splunkHEC_Configs.endpoint) {
            return nil
        }
        
        
        self.splunkHEC_Configs = splunkHEC_Configs
        splunkHEC_Request = SplunkHEC_Request(splunkHEC_Configs:splunkHEC_Configs)
        
        
    }
    
    private func validate_init(splunk_URL:String,
                               endpoint:String) -> Bool{
        
        
        guard let _ = URL(string: splunk_URL) else {
            print(NSError(domain:"SplunkHec:Init Unable to set hec url: \(splunk_URL)", code:23).localizedDescription)
            return false
        }
        
        let available_endpoints = SplunkHEC_GlobalSettings().available_endpoints
        
        if available_endpoints.keys.contains(endpoint) {
            return true
        }
        else {
            print(NSError(domain:"SplunkHec:Init Unable to select endpoint: '\(endpoint)'. Must be \(available_endpoints.keys.description)", code:24).localizedDescription)
            return false
        }
        
        
    }
    
    
    public func check_health() -> Bool {
        var healthy:Bool = false
        let wait_for_health = DispatchSemaphore(value: 0)
        
        splunkHEC_Request.hec_health() { (success,error) in
            if success {
                healthy = true
            }
            else {
                healthy = false
                print(error!.localizedDescription)
            }
            wait_for_health.signal()
        }
        

        wait_for_health.wait()
        
        return healthy
    }
    
    public func start_session() -> SplunkHEC_Session? {
        if current_splunkHEC_Session == nil {
            current_splunkHEC_Session = SplunkHEC_Session(splunkHEC_Configs: splunkHEC_Configs, splunkHEC_Request: splunkHEC_Request)
            current_splunkHEC_Session.start_session()
            return current_splunkHEC_Session
        }
        else {
            print(NSError(domain:"SplunkHec:Session Already started.", code:21).localizedDescription)
            return nil
        }
        
    }
    
    public func stop_session() -> Bool {
        if current_splunkHEC_Session != nil {
            if current_splunkHEC_Session.is_active {
                current_splunkHEC_Session.stop_session()
                current_splunkHEC_Session = nil
                return true
            }
        }
        
        print(NSError(domain:"SplunkHec:Session session not started.", code:22).localizedDescription)
        return false
    }
    
}
