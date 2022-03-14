//
//  SplunkHECTests.swift
//  SplunkHECTests
//
//  Created by rg on 2/28/22.
//

import XCTest
@testable import SplunkHEC

class SplunkHECTests: XCTestCase {

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
    
    func test_setUp_hecHealthy() {
        XCTAssertTrue(splunkHEC.check_health())
    }
    
    
    
    func test_sendData_systemInfos() {
        let splunkHEC_Session:SplunkHEC_Session = splunkHEC!.start_session()
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        splunkHEC_Log.system_info()
        splunkHEC_Log.system_info(level: "INFO")
        
        splunkHEC.stop_session()
        XCTAssertTrue(true)
        
    }
    
    func test_sendData_infos() {
         let splunkHEC_Session:SplunkHEC_Session = splunkHEC.start_session()
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        let test_logMessage = UUID().uuidString
        
        splunkHEC_Log.info(message: test_logMessage + " level=info input=string")
        splunkHEC_Log.i(message: test_logMessage + " level=info input=string")
        splunkHEC_Log.info(message: ["message":test_logMessage, "level":"info", "input":"dict"])
        splunkHEC_Log.i(message: ["message":test_logMessage, "level":"info", "input":"dict"])
        
        splunkHEC.stop_session()
        XCTAssertTrue(true)
        
        
    }
    
    func test_sendData_warns() {
        let splunkHEC_Session:SplunkHEC_Session = splunkHEC.start_session()
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        let test_logMessage = UUID().uuidString
        
        splunkHEC_Log.warn(message: test_logMessage + " level=warn input=string")
        splunkHEC_Log.w(message: test_logMessage + " level=warn input=string")
        splunkHEC_Log.warn(message: ["message":test_logMessage, "level":"warn", "input":"dict"])
        splunkHEC_Log.w(message: ["message":test_logMessage, "level":"warn", "input":"dict"])
        
        splunkHEC.stop_session()
        XCTAssertTrue(true)
        
    }
    
    func test_sendData_errors() {
        let splunkHEC_Session:SplunkHEC_Session = splunkHEC.start_session()
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        let test_logMessage = UUID().uuidString
        
        splunkHEC_Log.error(message: test_logMessage + " level=error input=string")
        splunkHEC_Log.e(message: test_logMessage + " level=error input=string")
        splunkHEC_Log.error(message: ["message":test_logMessage, "level":"error", "input":"dict"])
        splunkHEC_Log.e(message: ["message":test_logMessage, "level":"error", "input":"dict"])
        
        splunkHEC.stop_session()
        XCTAssertTrue(true)
        
    }
    
    func test_sendData_fatals() {
        let splunkHEC_Session:SplunkHEC_Session = splunkHEC.start_session()
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        let test_logMessage = UUID().uuidString
        
        splunkHEC_Log.fatal(message: test_logMessage + " level=fatal input=string")
        splunkHEC_Log.f(message: test_logMessage + " level=fatal input=string")
        splunkHEC_Log.fatal(message: ["message":test_logMessage, "level":"fatal", "input":"dict"])
        splunkHEC_Log.f(message: ["message":test_logMessage, "level":"fatal", "input":"dict"])
        
        splunkHEC.stop_session()
        XCTAssertTrue(true)
        
    }
    
    func test_sendData_debugs() {
        let splunkHEC_Session:SplunkHEC_Session = splunkHEC.start_session()
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        let test_logMessage = UUID().uuidString
        
        splunkHEC_Log.debug(message: test_logMessage + " level=debug input=string")
        splunkHEC_Log.d(message: test_logMessage + " level=debug input=string")
        splunkHEC_Log.debug(message: ["message":test_logMessage, "level":"debug", "input":"dict"])
        splunkHEC_Log.d(message: ["message":test_logMessage, "level":"debug", "input":"dict"])
        
        splunkHEC.stop_session()
        XCTAssertTrue(true)
        
    }
    
    func test_sendData_generics() {
        let splunkHEC_Session:SplunkHEC_Session = splunkHEC.start_session()
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        let test_logMessage = UUID().uuidString
        
        splunkHEC_Log.event(message: test_logMessage + " level=none input=string")
        splunkHEC_Log.event(message: ["message":test_logMessage, "level":"none", "input":"dict"])
        
        splunkHEC.stop_session()
        XCTAssertTrue(true)
        
    }
    
    func test_config_logFormat() {
        let splunkHEC_Configs = SplunkHEC_Configs(
                                hec_token: splunkHECTestsConfigs.hec_token,
                                splunk_URL: splunkHECTestsConfigs.splunk_url,
                                enforce_SSL: false,
                                log_format:"%timestamp% - [%session_id%] - customFormat %message%")
        

        guard let splunkHEC_withConfig:SplunkHEC = SplunkHEC(splunkHEC_Configs:splunkHEC_Configs) else {
            XCTAssertTrue(false)
            return
        }
        
        let splunkHEC_Session:SplunkHEC_Session = splunkHEC_withConfig.start_session()
            
        let splunkHEC_Log = splunkHEC_Session.Log
        
        let test_logMessage = UUID().uuidString
        
        splunkHEC_Log.event(message: test_logMessage + " test=customFormat level=none input=string")
        
        splunkHEC_withConfig.stop_session()
        XCTAssertTrue(true)
        
    }
    
    func test_config_timeFormat() {
        
        let splunkHEC_Configs = SplunkHEC_Configs(
                                hec_token: splunkHECTestsConfigs.hec_token,
                                splunk_URL: splunkHECTestsConfigs.splunk_url,
                                enforce_SSL: false,
                                time_format:"yyyy-MM-dd HH:mm:ss")
        

        guard let splunkHEC_withConfig:SplunkHEC = SplunkHEC(splunkHEC_Configs:splunkHEC_Configs) else {
            XCTAssertTrue(false)
            return
        }
        
        let splunkHEC_Session:SplunkHEC_Session = splunkHEC_withConfig.start_session()
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        let test_logMessage = UUID().uuidString
        
        splunkHEC_Log.event(message: test_logMessage + " test=customTime level=none input=string")
        
        splunkHEC_withConfig.stop_session()
        XCTAssertTrue(true)
        
    }
    
    func test_config_rawEndpoint() {
        let splunkHEC_Configs = SplunkHEC_Configs(
                                hec_token: splunkHECTestsConfigs.hec_token,
                                splunk_URL: splunkHECTestsConfigs.splunk_url,
                                endpoint: "raw",
                                enforce_SSL: false,
                                static_fields: SplunkHEC_Fields(host: "myiPhone", source: "UnitTests", fields: ["mycustomfield1":"mycustomvalue"]
                                
                                ) //static fields shouldn't show up on raw
                                )
        

        guard let splunkHEC_withConfig:SplunkHEC = SplunkHEC(splunkHEC_Configs:splunkHEC_Configs) else {
            XCTAssertTrue(false)
            return
        }
        
        let splunkHEC_Session:SplunkHEC_Session = splunkHEC_withConfig.start_session()
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        let test_logMessage = UUID().uuidString
        
        splunkHEC_Log.event(message: test_logMessage + " test=raw level=none input=string")
        
        splunkHEC_withConfig.stop_session()
        XCTAssertTrue(true)
        
    }
    
    func test_config_staticFields() {
        let splunkHEC_Configs = SplunkHEC_Configs(
                                hec_token: splunkHECTestsConfigs.hec_token,
                                splunk_URL: splunkHECTestsConfigs.splunk_url,
                                enforce_SSL: false,
                                static_fields: SplunkHEC_Fields(host: "myiPhone", source: "UnitTests", fields: ["mycustomfield1":"mycustomvalue"]
                                
                                ) )
        

        guard let splunkHEC_withConfig:SplunkHEC = SplunkHEC(splunkHEC_Configs:splunkHEC_Configs) else {
            XCTAssertTrue(false)
            return
        }
        
        let splunkHEC_Session:SplunkHEC_Session = splunkHEC_withConfig.start_session()
        
        let splunkHEC_Log = splunkHEC_Session.Log
        
        let test_logMessage = UUID().uuidString
        
        splunkHEC_Log.event(message: test_logMessage + " test=customFields level=none input=string")
        
        splunkHEC_withConfig.stop_session()
        
        XCTAssertTrue(true)
        
    }
    
    
}
