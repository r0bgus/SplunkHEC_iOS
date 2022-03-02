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
        
        splunkHEC = SplunkHEC(splunkHEC_Configs: SplunkHEC_Configs(HEC_Token: splunkHECTestsConfigs.hec_token, SplunkHEC_URL: splunkHECTestsConfigs.splunk_url, enforce_SSL: false))
        print("Starting test. Token: \(splunkHECTestsConfigs.hec_token) URL: \(splunkHECTestsConfigs.splunk_url)")
    }

    override func tearDownWithError() throws {
        splunkHEC = nil
        
        try super.tearDownWithError()
    }
    
    func test_setUp_hecHealthy() {
        XCTAssertTrue(splunkHEC.check_health())
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
        
        
        guard let splunkHEC_Session:SplunkHEC_Session = splunkHEC.start_session() else {
            XCTAssertTrue(false)
            return
        }
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        for i in stride(from:0,to:numPayloads, by:1) {
            splunkHEC_Log.i(message: test_logMessage + " size=\(startSize)")
        }
        sleep(20)
        
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
        
        guard let splunkHEC_Session:SplunkHEC_Session = splunkHEC.start_session() else {
            XCTAssertTrue(false)
            return
        }
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        for i in stride(from:0,to:numPayloads, by:1) {
            splunkHEC_Log.i(message: test_logMessage + " i=\(i)")
        }
        sleep(20)
        
        print("Sent num_payloads: \(numPayloads)")
        
        splunkHEC.stop_session()
        
        XCTAssertTrue(true)
    }

}
