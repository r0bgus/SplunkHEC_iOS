//
//  SystemInfo.swift
//  
//
//  Created by rg on 2/8/22.
//

import Foundation
import UIKit

struct SplunkHEC_SystemInfo {
    
    //collect basic information about the device
    let deviceName:String = UIDevice.current.name
    let systemVersion:String = UIDevice.current.systemVersion
    let deviceModel:String = UIDevice.current.model
    
    //is wifi
    //ip address
    
    
    func description() -> String {
        return SplunkHEC_Utils().dict2KV(dict:values())
    }
    
    func values() -> [String:String] {
        return ["deviceName":deviceName, "systemVersion":systemVersion, "deviceModel":deviceModel]
    }
    
    
    
    
}
