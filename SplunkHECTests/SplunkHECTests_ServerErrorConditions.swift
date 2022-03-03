//
//  SplunkHECTests_ServerErrorConditions.swift
//  SplunkHECTests
//
//  Created by rg on 3/1/22.
//

import XCTest
@testable import SplunkHEC

class SplunkHECTests_ServerErrorConditions: XCTestCase {

    var splunkHECTestsConfigs = SplunkHECTests_Configs()
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func test_healthCheck() {
                
        let splunkHEC_Configs = SplunkHEC_Configs(
                                hec_token: splunkHECTestsConfigs.hec_token,
                                splunk_URL: splunkHECTestsConfigs.splunk_url,
                                enforce_SSL: false)
        
        guard let splunkHEC_withConfig:SplunkHEC = SplunkHEC(splunkHEC_Configs:splunkHEC_Configs) else {
            XCTAssertTrue(false)
            return
        }
        
        XCTAssertTrue(splunkHEC_withConfig.check_health())
        
    }
    
    func test_sendData_invalidToken() {
        
        var hec_token = "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
        
        let splunkHEC_Configs = SplunkHEC_Configs(
                                hec_token: hec_token,
                                splunk_URL: splunkHECTestsConfigs.splunk_url,
                                enforce_SSL: false)
        
        guard let splunkHEC_withConfig:SplunkHEC = SplunkHEC(splunkHEC_Configs:splunkHEC_Configs) else {
            XCTAssertTrue(false)
            return
        }
        
        guard let splunkHEC_Session:SplunkHEC_Session = splunkHEC_withConfig.start_session() else {
            XCTAssertTrue(false)
            return
        }
        
        var splunkHEC_Log = splunkHEC_Session.Log
        
        splunkHEC_Log.i(message: "bad token")
        
        splunkHEC_withConfig.stop_session()
        
        sleep(5)
        
        //soft fail check logs
        
    }
    

}
