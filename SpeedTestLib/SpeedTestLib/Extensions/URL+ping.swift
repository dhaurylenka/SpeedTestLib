//
//  URL+ping.swift
//  SpeedTestLib
//
//  Created by dhaurylenka on 2/5/18.
//  Copyright © 2018 Exadel. All rights reserved.
//

import Foundation

extension URL {
    func ping(timeout: TimeInterval, closure: @escaping (Result<Int, NetworkError>) -> ()) {
        let startTime = Date()
        URLSession(configuration: .default).dataTask(with: URLRequest(url: self, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeout)) { (data, response, error) in
            let value = startTime.timeIntervalSinceNow
            
            if let _ = error {
                closure(.error(NetworkError.requestFailed)); return
            }
            guard let response = response, response.isOk else {
                closure(.error(NetworkError.requestFailed)); return
            }
            
            let pingms = (fmod(-value, 1) * 1000)
            closure(.value(Int(pingms)))
        }.resume()
    }
}

