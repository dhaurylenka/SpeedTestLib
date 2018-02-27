//
//  UploadServiceTests.swift
//  SpeedTestLibTests
//
//  Created by dhaurylenka on 2/6/18.
//  Copyright © 2018 Exadel. All rights reserved.
//

import XCTest
@testable import SpeedTestLib

class UploadServiceTests: XCTestCase {
    func testRealUploadService() {
        let sut = CustomHostUploadService()
        
        let exp = expectation(description: "Eboy!")
        
        sut.test(URL(string: "http://test.byfly.by/speedtest/upload.php")!,
                 fileSize: 2500000,
                 timeout: 30,
                 current: { (current, avg) in
                    print("current: " + current.description)
                    print("avg: " + avg.description)
                }, final: { result in
                    exp.fulfill()
                })
        
        wait(for: [exp], timeout: 30)
    }
}
