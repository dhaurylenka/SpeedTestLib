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
        
        sut.test(URL(string: "http://test.byfly.by/speedtest/upload.php" /*"http://test.byfly.by:8080/upload?nocache=89a90eb1-44de-444c-a6a6-fd8ffbebb835"*/)!,
                 current: { (current, avg) in
                    print("current: " + current.description)
                    print("avg: " + avg.description)
        }, final: { result in
            exp.fulfill()
        })
        
        wait(for: [exp], timeout: 30)
    }
}
