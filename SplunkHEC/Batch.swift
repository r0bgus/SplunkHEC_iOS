//
//  Batch.swift
//  
//
//  Created by rg on 2/8/22.
//

import Foundation

public struct SplunkHEC_Batch_Configs {
    //var milliSeconds_Buffer:Int = 5000 //1 second
    public var bytes_Buffer:Int!
    public var num_events:Int!
    
    public init(bytes_Buffer:Int = 1024, //1kb
                num_events:Int = 25 //value of 0 or negative disables this value
    ) {
        self.bytes_Buffer = bytes_Buffer
        self.num_events = num_events
    }
    
}

class SplunkHEC_Batch {
    
    let splunkHEC_Batch_Configs:SplunkHEC_Batch_Configs
    
    var batch:[String] = []
    var curSize:Int = 0
    var curEvents:Int = 0
    
    init(splunkHEC_Batch_Configs:SplunkHEC_Batch_Configs) {
        self.splunkHEC_Batch_Configs = splunkHEC_Batch_Configs
    }
    
    init() {
        splunkHEC_Batch_Configs = SplunkHEC_Batch_Configs()
    }
    
    func append(payload_string:String) -> [String] {
        
        let data_size = payload_string.utf8.count
        
        var tmp_batch:[String] = []
        
        if curSize + data_size > splunkHEC_Batch_Configs.bytes_Buffer ||
            (curEvents >= splunkHEC_Batch_Configs.num_events && splunkHEC_Batch_Configs.num_events > 0)
        {
            //flush
            tmp_batch = flush()

        }
        
        batch.append(payload_string)
        curSize += data_size
        curEvents += 1
        
        return tmp_batch
        
    }
    
    func flush() -> [String] {
        let tmp_batch = batch
        batch = []
        curSize = 0
        curEvents = 0
        return tmp_batch
    }
    
}
