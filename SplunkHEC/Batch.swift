//
//  Batch.swift
//  
//
//  Created by rg on 2/8/22.
//

import Foundation

public struct SplunkHEC_Batch_Configs {
    var milliSeconds_Buffer:Int
    public var bytes_Buffer:Int
    public var num_events:Int
    
    public init(bytes_Buffer:Int = 512*1024, //.5Mb
                num_events:Int = 250, //value of 0 or negative disables this value
                milliSeconds_Buffer:Int = 5000 //5 seconds
    ) {
        self.bytes_Buffer = bytes_Buffer
        self.num_events = num_events
        self.milliSeconds_Buffer = milliSeconds_Buffer
    }
    
}

class SplunkHEC_Batch {
    
    let splunkHEC_Batch_Configs:SplunkHEC_Batch_Configs
    
    lazy private var batch:[String] = []
    var curSize:Int = 0
    var curEvents:Int = 0
        
    let batch_write_lock = NSLock()
    
    init(splunkHEC_Batch_Configs:SplunkHEC_Batch_Configs) {
        self.splunkHEC_Batch_Configs = splunkHEC_Batch_Configs

    }
    
    init() {
        splunkHEC_Batch_Configs = SplunkHEC_Batch_Configs()        
    }
    
    func append(payload_string:String) -> [String] {
        
        let data_size = payload_string.utf8.count
        
        return batch_write_lock.with {
            var tmp_batch:[String] = []
            
            if curSize + data_size > splunkHEC_Batch_Configs.bytes_Buffer ||
                (curEvents >= splunkHEC_Batch_Configs.num_events && splunkHEC_Batch_Configs.num_events > 0)
            {
                tmp_batch = flushLocked()
            }
            
            batch.append(payload_string)
            curSize += data_size
            curEvents += 1
            
            return tmp_batch
        }
        
    }
    
    func flush() -> [String] {
        batch_write_lock.with { flushLocked() }
    }
    
    private func flushLocked() -> [String] {
        let tmp_batch = batch
        batch.removeAll()
        curSize = 0
        curEvents = 0
        return tmp_batch
    }
    
}


//https://stackoverflow.com/questions/28191079/create-thread-safe-array-in-swift
extension NSLock {

    @discardableResult
    func with<T>(_ block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}
