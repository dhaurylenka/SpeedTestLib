//
//  SpeedTestServiceAPI.swift
//  SpeedTestLib
//
//  Created by dhaurylenka on 2/5/18.
//  Copyright © 2018 Exadel. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case requestFailed
    case wrongContentType
    case wrongJSON
}

public protocol HostsProviderService {
    func getHosts(timeout: TimeInterval, closure: @escaping (Result<[SpeedTestHost], NetworkError>) -> ())
    func getHosts(max: Int, timeout: TimeInterval, closure: @escaping (Result<[SpeedTestHost], NetworkError>) -> ())
}

public protocol HostPingService {
    func ping(url: URL, timeout: TimeInterval, closure: @escaping (Result<Int, NetworkError>) -> ())
}

protocol SpeedService {
    func test(_ url: URL, fileSize: Int, timeout: TimeInterval, current: @escaping (Speed, Speed) -> (), final: @escaping (Result<Speed, NetworkError>) -> ())
}

extension SpeedService {
    func calculate(bytes: Int64, seconds: TimeInterval) -> Speed {
        return Speed(bytes: bytes, seconds: seconds).pretty
    }
    
    func sessionConfiguration(timeout: TimeInterval) -> URLSessionConfiguration {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeout
        sessionConfig.timeoutIntervalForResource = timeout
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        sessionConfig.urlCache = nil
        return sessionConfig
    }
}
