//
//  SplunkHECTests_Batch.swift
//  SplunkHECTests
//
//  Created by rg on 3/1/22.
//

import XCTest
@testable import SplunkHEC

class SplunkHECTests_Batch: XCTestCase {

    var splunkHEC:SplunkHEC!
    var splunkHECTestsConfigs = SplunkHECTests_Configs()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        splunkHEC = SplunkHEC(splunkHEC_Configs: SplunkHEC_Configs(hec_token: splunkHECTestsConfigs.hec_token, splunk_URL: splunkHECTestsConfigs.splunk_url, enforce_SSL: false))
        print("Starting test. Token: \(splunkHECTestsConfigs.hec_token) URL: \(splunkHECTestsConfigs.splunk_url)")
    }

    override func tearDownWithError() throws {
        splunkHEC = nil
        
        try super.tearDownWithError()
    }
    


    func test_sendData_batchDataSizeDefault() {
        var test_logMessage:String = ""
        
        let testDataSize = 3*1024 //bytes
        let numPayloads = 25
        var startSize = 0
        
        while startSize < testDataSize/numPayloads {
            var newString = UUID().uuidString
            test_logMessage = test_logMessage + newString
            startSize += newString.utf8.count
        }
        
        
        let splunkHEC_Session:SplunkHEC_Session = splunkHEC.start_session()
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        for i in stride(from:0,to:numPayloads, by:1) {
            splunkHEC_Log.i(message: test_logMessage + " type=batchSize size=\(startSize)")
        }
        let sleep_time = 5.0
        let now = Date().timeIntervalSince1970
        while now + sleep_time > Date().timeIntervalSince1970 {
            
            //waiting for sleep_time
        }
        
        print("Sent num_payloads: \(numPayloads)")
        print("Events per payload: \(1024/startSize)")
        
        splunkHEC.stop_session()
        
        XCTAssertTrue(true)
    }
    
    func test_sendData_batchEventSizeDefault() {
        var test_logMessage:String = ""
        
        let numPayloads = 25
        var startSize = 0
        
        while startSize < 200 {
            var newString = UUID().uuidString
            test_logMessage = test_logMessage + newString
            startSize += newString.utf8.count
        }
        
        let splunkHEC_Session:SplunkHEC_Session = splunkHEC.start_session()
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        for i in stride(from:0,to:numPayloads, by:1) {
            splunkHEC_Log.i(message: test_logMessage + " type=batchEvent i=\(i)")
        }
        sleep(10)
        
        print("Sent num_payloads: \(numPayloads)")
        
        splunkHEC.stop_session()
        
        
        XCTAssertTrue(true)
    }
    
    func test_sendData_batchEventTimeDefault() {
        var test_logMessage:String = ""
        
        let numPayloads = 25
        var startSize = 0
        
        while startSize < 200 {
            var newString = UUID().uuidString
            test_logMessage = test_logMessage + newString
            startSize += newString.utf8.count
        }
        
        let splunkHEC_Session:SplunkHEC_Session = splunkHEC.start_session()
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        for i in stride(from:0,to:numPayloads, by:1) {
            splunkHEC_Log.i(message: test_logMessage + " type=batchTime i=\(i)")
            if i%5==0 {
                sleep(5)
            }
        }
        
        print("Sent num_payloads: \(numPayloads)")
        
        splunkHEC.stop_session()
                
        sleep(5)
        
        XCTAssertTrue(true)
    }
    
    func test_sendData_batchEventTimeCustom() {
        
        let splunkHEC_Configs = SplunkHEC_Configs(
                                hec_token: splunkHECTestsConfigs.hec_token,
                                splunk_URL: splunkHECTestsConfigs.splunk_url,
                                splunkHEC_Batch_Configs: SplunkHEC_Batch_Configs(milliSeconds_Buffer: 1500)
                                )
        
        guard let splunkHEC_withConfig:SplunkHEC = SplunkHEC(splunkHEC_Configs:splunkHEC_Configs) else {
            XCTAssertTrue(false)
            return
        }
        
        let splunkHEC_Session:SplunkHEC_Session = splunkHEC_withConfig.start_session()
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        var test_logMessage:String = ""
        
        let numPayloads = 25
        var startSize = 0
        
        while startSize < 200 {
            var newString = UUID().uuidString
            test_logMessage = test_logMessage + newString
            startSize += newString.utf8.count
        }
        
        for i in stride(from:0,to:numPayloads, by:1) {
            splunkHEC_Log.i(message: test_logMessage + " type=batchTime i=\(i)")
            if i%5==0 {
                sleep(5)
            }
        }
        
        print("Sent num_payloads: \(numPayloads)")
        
        splunkHEC.stop_session()
                
        sleep(5)
        
        XCTAssertTrue(true)
    }

}
