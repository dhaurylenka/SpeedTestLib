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
        
        sut.test(URL(string: "http://test.byfly.by/speedtest/upload.php")!,
                 fileSize: 2500000,
                 current: { (current, avg) in
                    print(current)
                    print(avg)
                }, final: { result in
                    exp.fulfill()
                })
        
        wait(for: [exp], timeout: 30)
    }
}
