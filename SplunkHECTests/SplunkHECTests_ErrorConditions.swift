//
//  SplunkHECTests_ErrorConditions.swift
//  SplunkHECTests
//
//  Created by rg on 3/1/22.
//

import XCTest
@testable import SplunkHEC

class SplunkHECTests_ErrorConditions: XCTestCase {
    
    var splunkHECTestsConfigs = SplunkHECTests_Configs()

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func test_configError_badURL() {
        var hec_token = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
        var splunk_url = "http://<hec>.badserver.url"
        
        let splunkHEC_Configs = SplunkHEC_Configs(
                                hec_token: hec_token,
                                splunk_URL: splunk_url)
        
        guard let splunkHEC_withConfig:SplunkHEC = SplunkHEC(splunkHEC_Configs:splunkHEC_Configs) else {
            XCTAssertTrue(true)
            return
        }
        
        XCTAssertTrue(false)
        
    }
    
    func test_configError_badEndpoint() {
        var hec_token = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
        var splunk_url = "http://hec.goodserver.url"
        
        let splunkHEC_Configs = SplunkHEC_Configs(
                                hec_token: hec_token,
                                splunk_URL: splunk_url,
                                endpoint: "nonexsitent")
        
        guard let splunkHEC_withConfig:SplunkHEC = SplunkHEC(splunkHEC_Configs:splunkHEC_Configs) else {
            XCTAssertTrue(true)
            return
        }
        
        XCTAssertTrue(false)
        
    }
    
    func test_session_alreadyStarted() {
        
        let splunkHEC_Configs = SplunkHEC_Configs(
                                hec_token: splunkHECTestsConfigs.hec_token,
                                splunk_URL: splunkHECTestsConfigs.splunk_url
                                )
        
        guard let splunkHEC_withConfig:SplunkHEC = SplunkHEC(splunkHEC_Configs:splunkHEC_Configs) else {
            XCTAssertTrue(false)
            return
        }
        
        guard let splunkHEC_Session:SplunkHEC_Session = splunkHEC_withConfig.start_session() else {
            XCTAssertTrue(false)
            return
        }
        guard let splunkHEC_Session:SplunkHEC_Session = splunkHEC_withConfig.start_session() else {
            XCTAssertTrue(true)
            return
        }
        
        XCTAssertTrue(false)
        
    }
    
    func test_session_notStarted() {
        
        let splunkHEC_Configs = SplunkHEC_Configs(
                                hec_token: splunkHECTestsConfigs.hec_token,
                                splunk_URL: splunkHECTestsConfigs.splunk_url
                                )
        
        guard let splunkHEC_withConfig:SplunkHEC = SplunkHEC(splunkHEC_Configs:splunkHEC_Configs) else {
            XCTAssertTrue(false)
            return
        }
        
        guard let splunkHEC_Session:SplunkHEC_Session = splunkHEC_withConfig.start_session() else {
            XCTAssertTrue(false)
            return
        }
        var session_stopped = splunkHEC_withConfig.stop_session()
        session_stopped = splunkHEC_withConfig.stop_session()

        XCTAssertFalse(session_stopped)
        
        
    }
    
    func test_session_logAfterSessionStop() {
        
        let splunkHEC_Configs = SplunkHEC_Configs(
                                hec_token: splunkHECTestsConfigs.hec_token,
                                splunk_URL: splunkHECTestsConfigs.splunk_url
                                )
        
        guard let splunkHEC_withConfig:SplunkHEC = SplunkHEC(splunkHEC_Configs:splunkHEC_Configs) else {
            XCTAssertTrue(false)
            return
        }
        
        guard let splunkHEC_Session:SplunkHEC_Session = splunkHEC_withConfig.start_session() else {
            XCTAssertTrue(false)
            return
        }
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        splunkHEC_withConfig.stop_session()
        
        splunkHEC_Log.i(message:"Logging after stop.")
        
        //soft fail. check logs
        
    }
    
    func test_payload_unsupportedCharacters() {
        
        let splunkHEC_Configs = SplunkHEC_Configs(
                                hec_token: splunkHECTestsConfigs.hec_token,
                                splunk_URL: splunkHECTestsConfigs.splunk_url
                                )
        
        guard let splunkHEC_withConfig:SplunkHEC = SplunkHEC(splunkHEC_Configs:splunkHEC_Configs) else {
            XCTAssertTrue(false)
            return
        }
        
        guard let splunkHEC_Session:SplunkHEC_Session = splunkHEC_withConfig.start_session() else {
            XCTAssertTrue(false)
            return
        }
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        let bogusStr = String(
            bytes: [0xD8, 0x00] as [UInt8],
            encoding: String.Encoding.utf16BigEndian)!
        
        splunkHEC_Log.i(message:bogusStr)
        
        //soft fail. check logs
        
    }
    

}
