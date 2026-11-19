//
//  SystemInfo.swift
//  
//
//  Created by rg on 2/8/22.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

struct SplunkHEC_SystemInfo {
    
    //collect basic information about the device
    #if canImport(UIKit)
    let deviceName:String = UIDevice.current.name
    let systemVersion:String = UIDevice.current.systemVersion
    let deviceModel:String = UIDevice.current.model
    #else
    let deviceName:String = ProcessInfo.processInfo.hostName
    let systemVersion:String = ProcessInfo.processInfo.operatingSystemVersionString
    let deviceModel:String = "Mac"
    #endif
    
    //is wifi
    //ip address
    
    
    func description() -> String {
        return SplunkHEC_Utils().dict2KV(dict:values())
    }
    
    func values() -> [String:String] {
        return ["deviceName":deviceName, "systemVersion":systemVersion, "deviceModel":deviceModel]
    }
    
    
    
}
