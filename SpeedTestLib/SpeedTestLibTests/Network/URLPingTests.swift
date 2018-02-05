//
//  URLPingTests.swift
//  SpeedTestLibTests
//
//  Created by dhaurylenka on 2/5/18.
//  Copyright © 2018 Exadel. All rights reserved.
//

import XCTest
@testable import SpeedTestLib

class URLPingTests: XCTestCase {
    
    func testGooglePing() {
        let url = URL(string: "http://google.com")!
        
        let exp = expectation(description: "Ping")
        
        url.ping(timeout: 10) { result in
            switch result {
            case .error(_):
                XCTFail()
            case .value(let value):
                XCTAssert(value > 0)
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 10)
    }
}
