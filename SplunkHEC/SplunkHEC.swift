//
//  SplunkHec.swift
//
//  Created by rg on 2/7/22.
//

import Foundation

public struct SplunkHEC_Configs {
    let available_endpoints:[String:String] = ["event":"/services/collector/event","raw":"/services/collector/raw","health":"/services/collector/health"]
    
    public var HEC_Token:String = ""
    public var SplunkHEC_URL:String = ""
    public var enforce_SSL:Bool = true
    public var endpoint:String = "event"
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
    public var log_format:String = "%timestamp% - %session_id% - [%level%][%file%:%line%][%function%] - %message%"
    public var time_format:String = "yyyy-MM-dd HH:mm:ss.SSS" //how time is displayed for %timestamp%. Note: when using hec event endpoint, a seperate timestamp is passed for indexing, making this timestamp purely cosmetic. When using the raw endpoint, the timestamp is used for line breaking and parsing.
    
    //batch configs
    public var splunkHEC_Batch_Configs:SplunkHEC_Batch_Configs = SplunkHEC_Batch_Configs()
    
    //static fields
    public var static_fields:SplunkHEC_Fields = SplunkHEC_Fields()
    
    
}

public final class SplunkHEC {
    
    private var splunkHEC_Configs:SplunkHEC_Configs!
    private var splunkHEC_Request:SplunkHEC_Request!
    private var current_splunkHEC_Session:SplunkHEC_Session!
    public var is_init:Bool = false
    
    public init?(hec_token:String,
          splunk_url:String,
          endpoint:String = "event") {
        
        splunkHEC_Configs = SplunkHEC_Configs()

        _ = set_hec_token(hec_token:hec_token)
        if set_splunk_url(splunk_url: splunk_url) == nil {
            return nil
        }
        
        if set_endpoint(endpoint: endpoint) == nil {
            return nil
        }
        
        splunkHEC_Request = SplunkHEC_Request(splunkHEC_Configs:splunkHEC_Configs)
        
        
    }
    
    public init?(splunkHEC_Configs: SplunkHEC_Configs) {
        
        self.splunkHEC_Configs = splunkHEC_Configs

        _ = set_hec_token(hec_token:self.splunkHEC_Configs.HEC_Token)
        if set_splunk_url(splunk_url: self.splunkHEC_Configs.SplunkHEC_URL) == nil {
            return nil
        }
        
        if set_endpoint(endpoint: self.splunkHEC_Configs.endpoint) == nil {
            return nil
        }
        
        splunkHEC_Request = SplunkHEC_Request(splunkHEC_Configs:splunkHEC_Configs)
        
        
    }
    
    private func set_hec_token(hec_token:String) -> String {
        splunkHEC_Configs.HEC_Token = hec_token
        return hec_token
    }
    
    private func set_splunk_url(splunk_url:String) -> String? {
        guard let _ = URL(string: splunk_url) else {
            print(NSError(domain:"SplunkHec:Init Unable to set hec url: \(splunk_url)", code:23).localizedDescription)
            return nil
        }
        
        splunkHEC_Configs.SplunkHEC_URL = splunk_url
        
        return splunk_url
    }
    
    private func set_endpoint(endpoint:String) -> String? {
        if splunkHEC_Configs.available_endpoints.keys.contains(endpoint) {
            splunkHEC_Configs.endpoint = endpoint
            return splunkHEC_Configs.available_endpoints[endpoint]
        }
        else {
            print(NSError(domain:"SplunkHec:Init Unable to select endpoint: '\(endpoint)'. Must be \(splunkHEC_Configs.available_endpoints.keys.description)", code:24).localizedDescription)
            return nil
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
