//
//  DownloadServiceTests.swift
//  SpeedTestLibTests
//
//  Created by dhaurylenka on 2/5/18.
//  Copyright © 2018 Exadel. All rights reserved.
//

import XCTest
@testable import SpeedTestLib

class DownloadServiceTests: XCTestCase {
    func testRealDownloadService() {
        let sut = CustomHostDownloadService()
        
        let exp = expectation(description: "Eboy!")
        
        sut.download(URL(string: "http://test.telecom.by:8080/download?size=25000000")!,
                     current: { (current, avg) in
                        print(current)
                        print(avg)
                    }, final: { result in
                        exp.fulfill()
                    })
        
        wait(for: [exp], timeout: 30)
    }
}
