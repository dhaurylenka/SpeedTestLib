//
//  DefaultHostPingService.swift
//  SpeedTestLib
//
//  Created by dhaurylenka on 2/5/18.
//  Copyright © 2018 Exadel. All rights reserved.
//

import Foundation

class DefaultHostPingService: HostPingService {
    func ping(url: URL, timeout: TimeInterval, closure: @escaping (Result<Int, NetworkError>) -> ()) {
        url.ping(timeout: timeout, closure: closure)
    }
}
