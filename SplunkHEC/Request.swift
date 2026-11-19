//
//  Request.swift
//  
//
//  Created by rg on 2/7/22.
//

import Foundation

class SplunkHEC_Request: NSObject, URLSessionDelegate {
    
    let available_endpoints = SplunkHEC_GlobalSettings().available_endpoints
    
    private var splunkHEC_Configs:SplunkHEC_Configs!
    private var session: URLSession!
    
    init(splunkHEC_Configs:SplunkHEC_Configs) {
        self.splunkHEC_Configs = splunkHEC_Configs
        super.init()
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 15
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    deinit {
        session.finishTasksAndInvalidate()
    }
    
    func hec_health(completion: @escaping (Bool,Error?) -> Void) {
        
        hec_get(endpoint: "health") { (_, status_code, error) in
            switch status_code {
            case 200:
                
                completion(true,nil)
                break
                
            case 400:
                
                completion(false,NSError(domain:"SplunkHec:Health (400) Invalid HEC Token", code:11))
                break
                
            case 503:
                
                completion(false,NSError(domain:"SplunkHec:Health (503) HEC is unhealthy", code:12))
                break
                
            default:
                
                completion(false,error ?? NSError(domain:"SplunkHec:Health unknown error", code:16))
                break
            }
        }
    }
    
    func hec_send_events(endpoint:String, data:String, completion: @escaping(Bool, Error?) -> Void) {
        
        guard let body = data.data(using: .utf8) else {
            completion(false, NSError(domain:"SplunkHec:POST unable to encode payload", code:17))
            return
        }
        
        hec_post(endpoint: endpoint, data: body) { (data, status_code, error) in
            switch status_code {
            case 200:
                completion(true,nil)
                break
            case 400,401,403,500,503:
                guard let hec_text = data?["text"] else {
                    completion(false, NSError(domain:"SplunkHec:POST (\(status_code)) Unknown error", code:13))
                    break
                }
                completion(false, NSError(domain:"SplunkHec:POST (\(status_code)) \(hec_text)", code:14))
                break
            default:
                completion(false,error ?? NSError(domain:"SplunkHec:POST unknown error", code:19))
                break
            }
            return
        }
    }
    
    
    func hec_post(endpoint:String, data:Data, completion: @escaping ([String: Any]?,Int,Error?) -> Void) {
        
        guard let Splunk_URL_endpoint = hec_endpoint_url(endpoint: endpoint) else {
            completion(nil, 0, NSError(domain:"SplunkHec:POST invalid endpoint or URL", code: 20))
            return
        }
        
        var hec_post_request = URLRequest(url: Splunk_URL_endpoint)
                
        //method, header, body
        hec_post_request.httpMethod = "POST"
        hec_post_request.setValue("Splunk \(splunkHEC_Configs.hec_token)", forHTTPHeaderField: "Authorization")
        hec_post_request.httpBody = data
        
        let hec_post_task = session.dataTask(with: hec_post_request) { data, response, error in

            guard let data = data, error==nil else {
                completion(nil, 0, error ?? NSError(domain:"SplunkHec:POST No data", code: 3))
                return
            }
            
            do {
                //create json object from data
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, 0, NSError(domain: "SplunkHec:POST invalidJSONTypeError", code: 4))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    completion(json,httpResponse.statusCode, nil)
                    return
                }
                
                else {
                    completion(nil, 0, NSError(domain: "SplunkHec:POST status code unavailable", code: 5))
                    return
                }
                
            } catch let error {
                completion(nil, 0, error)
                return
            }
            
        }
        
        hec_post_task.resume()
    }
    
    func hec_get(endpoint:String, completion: @escaping ([String: Any]?,Int,Error?) -> Void) {
        
        guard let Splunk_URL_endpoint = hec_endpoint_url(endpoint: endpoint) else {
            completion(nil, 0, NSError(domain:"SplunkHec:GET invalid endpoint or URL", code: 6))
            return
        }
        
        let hec_get_task = session.dataTask(with: Splunk_URL_endpoint) { (data, response, error) in
            guard let data = data else {
                completion(nil, 0, error ?? NSError(domain:"SplunkHec:GET No data", code: 0))
                
                return
            }
                           
            do {
                //create json object from data
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, 0, NSError(domain: "SplunkHec:GET invalidJSONTypeError", code: 1))
                    
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    completion(json,httpResponse.statusCode, nil)
                }
                else {
                    completion(nil, 0, NSError(domain: "SplunkHec:GET status code unavailable", code: 2))
                }
                
            } catch let error {
                completion(nil, 0, error)
            }
            
        }
        
        hec_get_task.resume()
        
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if splunkHEC_Configs.enforce_SSL == false {
        
            if let trust = challenge.protectionSpace.serverTrust {
                    let credential = URLCredential(trust: trust)
                    completionHandler(.useCredential, credential)
                    return
            }
            
            else {
                    completionHandler(.useCredential, nil)
                    return
            }
            
        }
        
        completionHandler(.useCredential, nil)
        
     }
    
    private func hec_endpoint_url(endpoint: String) -> URL? {
        guard let path = available_endpoints[endpoint] else {
            return nil
        }
        return URL(string: splunkHEC_Configs.splunk_URL + path)
    }
    
}
