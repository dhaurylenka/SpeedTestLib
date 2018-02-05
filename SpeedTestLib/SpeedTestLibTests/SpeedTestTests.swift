//
//  SpeedTestTests.swift
//  SpeedTestLibTests
//
//  Created by dhaurylenka on 2/5/18.
//  Copyright © 2018 Exadel. All rights reserved.
//

import XCTest
@testable import SpeedTestLib

class SpeedTestTests: XCTestCase {
    
    private var sut: SpeedTest!

    func testRealService() {
        sut = SpeedTest()
        
        let exp = expectation(description: "It's working!!!")
        
        sut.findBestHost(from: 5, timeout: 10) { result in
            switch result {
            case .error(let error):
                XCTFail(error.localizedDescription)
            case .value(let host):
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 10)
    }
}
