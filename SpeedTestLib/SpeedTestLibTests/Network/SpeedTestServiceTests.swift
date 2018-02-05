//
//  SpeedTestServiceTests.swift
//  SpeedTestLibTests
//
//  Created by dhaurylenka on 2/5/18.
//  Copyright © 2018 Exadel. All rights reserved.
//

import XCTest
@testable import SpeedTestLib

class SpeedTestServiceTests: XCTestCase {
    
    private var sut: HostsProviderService!
    private let standartTimeout: TimeInterval = 10
    
    override func setUp() {
        super.setUp()
        sut = SpeedTestService()
    }
    
    // Internet connection is needed. speedtest.net have to be reachable
    func testRealSpeedTestOneHost() {
        let exp = expectation(description: "We found hosts")
        sut.getHosts(max: 1, timeout: standartTimeout) { result in
            switch result {
            case .error(_):
                XCTFail()
            case .value(let hosts):
                XCTAssert(hosts.count == 1)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: standartTimeout)
    }
    
    // Internet connection is needed. speedtest.net have to be reachable
    func testRealSpeedTestTwoHost() {
        let exp = expectation(description: "We found hosts")
        sut.getHosts(max: 2, timeout: standartTimeout) { result in
            switch result {
            case .error(_):
                XCTFail()
            case .value(let hosts):
                XCTAssert(hosts.count == 2)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: standartTimeout)
    }
}
