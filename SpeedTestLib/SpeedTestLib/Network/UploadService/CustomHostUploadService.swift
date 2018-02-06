//
//  CustomHostUploadService.swift
//  SpeedTestLib
//
//  Created by dhaurylenka on 2/6/18.
//  Copyright © 2018 Exadel. All rights reserved.
//

import Foundation

class CustomHostUploadService: NSObject, SpeedService {
    private var responseDate: Date?
    private var latestDate: Date?
    private var current: ((Speed, Speed) -> ())!
    private var final: ((Speed) -> ())!
    
    func test(_ url: URL, current: @escaping (Speed, Speed) -> (), final: @escaping (Speed) -> ()) {
        self.current = current
        self.final = final
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main).uploadTask(with: request, from: Data(count: 9999999)).resume()
    }
}

extension CustomHostUploadService: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Swift.Void) {
        let result = calculate(bytes: dataTask.countOfBytesSent, seconds: Date().timeIntervalSince(self.responseDate!))
        DispatchQueue.main.async {
            self.final(result)
        }
    }
}

extension CustomHostUploadService: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        guard let startDate = responseDate, let latesDate = latestDate else {
            responseDate = Date();
            latestDate = responseDate
            return
        }
        
        let currentTime = Date()
        let timeSpend = currentTime.timeIntervalSince(latesDate)
        
        let current = calculate(bytes: bytesSent, seconds: timeSpend)
        let average = calculate(bytes: totalBytesSent, seconds: -startDate.timeIntervalSinceNow)
        
        latestDate = currentTime
        
        DispatchQueue.main.async {
            self.current(current, average)
        }
    }
}
