//
//  Request.swift
//  
//
//  Created by rg on 2/7/22.
//

import Foundation

class SplunkHEC_Request: NSObject, URLSessionDelegate {
    
    private var splunkHEC_Configs:SplunkHEC_Configs!
    
    
    init(splunkHEC_Configs:SplunkHEC_Configs) {
        
        self.splunkHEC_Configs = splunkHEC_Configs
        
    }
    
    func hec_health(completion: @escaping (Bool,Error?) -> Void) {
        
        hec_get(endpoint: "health") { (data, status_code, error) in
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
                
                completion(false,error)
                break
            }
        }
    }
    
    func hec_send_events(endpoint:String, data:String, completion: @escaping(Bool, Error?) -> Void) {
        hec_post(endpoint: endpoint, data: data.data(using: .ascii)!) { (data, status_code, error) in
            
            switch status_code {
            case 200:
                completion(true,nil)
                break
            case 400,401,403,500,503:
                guard let hec_text = data!["text"] else {
                    completion(false, NSError(domain:"SplunkHec:POST (\(status_code)) Unknown error", code:13))
                    break
                }
                completion(false, NSError(domain:"SplunkHec:POST (\(status_code)) \(hec_text)", code:13))
                break
            default:
                completion(false,error)
                break
            }
        }
        
    }
    
    
    func hec_post(endpoint:String, data:Data, completion: @escaping ([String: Any]?,Int,Error?) -> Void) {
    
        let Splunk_URL_endpoint = URL(string:splunkHEC_Configs.SplunkHEC_URL + splunkHEC_Configs.available_endpoints[endpoint]!)!
        
        var hec_post_request = URLRequest(url: Splunk_URL_endpoint)
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
        //method, header, body
        hec_post_request.httpMethod = "POST"
        hec_post_request.setValue("Splunk \(splunkHEC_Configs.HEC_Token)", forHTTPHeaderField: "Authorization")
        hec_post_request.httpBody = data
        
        let hec_post_task = session.dataTask(with: hec_post_request) { data, response, error in
            guard let data = data, error==nil else {
                completion(nil, 0, NSError(domain:"SplunkHec:POST No data", code: 3))
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
                }
                
                else {
                    completion(nil, 0, NSError(domain: "SplunkHec:POST status code unavailable", code: 5))
                }
                
            } catch let error {
                completion(nil, 0, error)
            }
            
        }
        
        hec_post_task.resume()
    }
    
    func hec_get(endpoint:String, completion: @escaping ([String: Any]?,Int,Error?) -> Void) {
        
        let Splunk_URL_endpoint = URL(string:splunkHEC_Configs.SplunkHEC_URL + splunkHEC_Configs.available_endpoints[endpoint]!)!
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        
        let hec_get_task = session.dataTask(with: Splunk_URL_endpoint) { (data, response, error) in
            guard let data = data else {
                completion(nil, 0, NSError(domain:"SplunkHec:GET No data", code: 0))
                
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
                print("6")
                completion(nil, 0, error)
            }
            
        }
        
        hec_get_task.resume()
        
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if splunkHEC_Configs.enforce_SSL == false {
        
            if challenge.protectionSpace.serverTrust == nil {
                    completionHandler(.useCredential, nil)
            }
            
            else {
                    let trust: SecTrust = challenge.protectionSpace.serverTrust!
                    let credential = URLCredential(trust: trust)
                    completionHandler(.useCredential, credential)
            }
            
        }
        
        completionHandler(.useCredential, nil)
        
     }
    
}

