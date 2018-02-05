//
//  SpeedTestServiceAPI.swift
//  SpeedTestLib
//
//  Created by dhaurylenka on 2/5/18.
//  Copyright © 2018 Exadel. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case requestFailed
    case wrongContentType
    case wrongJSON
}

protocol HostsProviderService {
    func getHosts(max: Int, timeout: TimeInterval, closure: @escaping (Result<[URL], NetworkError>) -> ())
}

protocol HostPingService {
    func ping(url: URL, timeout: TimeInterval, closure: @escaping (Result<Int, NetworkError>) -> ())
}
