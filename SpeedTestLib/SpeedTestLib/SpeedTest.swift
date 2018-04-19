//
//  SpeedTest.swift
//  SpeedTestLib
//
//  Created by dhaurylenka on 2/5/18.
//  Copyright © 2018 Exadel. All rights reserved.
//

import Foundation

public enum SpeedTestError: Error {
    case networkError
    case hostNotFound
}

public final class SpeedTest {
    private let hostService: HostsProviderService
    private let pingService: HostPingService
    private let downloadService = CustomHostDownloadService()
    private let uploadService = CustomHostUploadService()
    
    public required init(hosts: HostsProviderService, ping: HostPingService) {
        self.hostService = hosts
        self.pingService = ping
    }
    
    public convenience init() {
        self.init(hosts: SpeedTestService(), ping: DefaultHostPingService())
    }
    
    public func findHosts(timeout: TimeInterval, closure: @escaping (Result<[SpeedTestHost], SpeedTestError>) -> ()) {
        hostService.getHosts(timeout: timeout) { result in
            switch result {
            case .value(let hosts):
                DispatchQueue.main.async {
                    closure(.value(hosts))
                }
            case .error(_):
                DispatchQueue.main.async {
                    closure(.error(.networkError))
                }
            }
        }
    }
    
    public func findBestHost(from max: Int, timeout: TimeInterval, closure: @escaping (Result<(URL, Int), SpeedTestError>) -> ()) {
        hostService.getHosts(max: max, timeout: timeout) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .error(_):
                DispatchQueue.main.async {
                    closure(.error(.networkError))
                }
            case .value(let hosts):
                strongSelf.pingAllHosts(hosts: hosts.map { $0.url }, timeout: timeout) { pings in
                    DispatchQueue.main.async {
                        closure(strongSelf.findBestPings(from: pings))
                    }
                }
            }
        }
    }
    
    public func ping(host: SpeedTestHost, timeout: TimeInterval, closure: @escaping (Result<Int, SpeedTestError>) -> ()) {
        pingService.ping(url: host.url, timeout: timeout) { result in
            DispatchQueue.main.async {
                switch result {
                case .value(let ping):
                    closure(.value(ping))
                case .error(_):
                    closure(.error(.networkError))
                }
            }
        }
    }
    
    public func runDownloadTest(for host: URL, size: Int, timeout: TimeInterval, current: @escaping (Speed) -> (), final: @escaping (Result<Speed, NetworkError>) -> ()) {
        downloadService.test(host,
                             fileSize: size,
                             timeout: timeout,
                             current: { (_, avgSpeed) in
                                current(avgSpeed)
                            }, final: { result in
                                final(result)
                            })
    }
    
    public func runUploadTest(for host: URL, size: Int, timeout: TimeInterval, current: @escaping (Speed) -> (), final: @escaping (Result<Speed, NetworkError>) -> ()) {
        uploadService.test(host,
                           fileSize: size,
                           timeout: timeout,
                           current: { (_, avgSpeed) in
                            current(avgSpeed)
                        }, final: { result in
                            final(result)
                        })
    }
    
    private func pingAllHosts(hosts: [URL], timeout: TimeInterval, closure: @escaping ([(host: URL, ping: Int)]) -> ()) {
        let group = DispatchGroup()
        var pings = [(URL, Int)]()
        hosts.forEach { url in
            group.enter()
            pingService.ping(url: url, timeout: timeout, closure: { result in
                switch result {
                case .error(_): break
                case .value(let ping):
                    pings.append((url, ping))
                }
                group.leave()
            })
        }
        group.notify(queue: DispatchQueue.global(qos: .default)) {
            closure(pings)
        }
    }
    
    private func findBestPings(from pings: [(host: URL, ping: Int)]) -> Result<(URL, Int), SpeedTestError> {
        let best = pings.min(by: { (left, right) in
            left.ping < right.ping
        })
        if let best = best {
            return .value(best)
        } else {
            return .error(.hostNotFound)
        }
    }
}
