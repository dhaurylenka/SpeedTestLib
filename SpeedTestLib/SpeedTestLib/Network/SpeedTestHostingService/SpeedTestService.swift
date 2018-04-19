//
//  SpeedTestService.swift
//  SpeedTestLib
//
//  Created by dhaurylenka on 2/5/18.
//  Copyright © 2018 Exadel. All rights reserved.
//

import Foundation

final internal class SpeedTestService: HostsProviderService {
    private let url: URL
    
    required init(url: URL) {
        self.url = url
    }
    
    convenience init() {
        self.init(url: URL(string: "https://beta.speedtest.net/api/js/servers?engine=js")!)
    }
    
    func getHosts(timeout: TimeInterval, closure: @escaping (Result<[SpeedTestHost], NetworkError>) -> ()) {
        URLSession(configuration: .default).dataTask(with: URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: timeout)) { (data, response, error) in
            if let _ = error {
                closure(.error(NetworkError.requestFailed)); return
            }
            
            guard let response = response, response.isOk, let data = data else {
                closure(.error(NetworkError.requestFailed)); return
            }
            
            guard response.isJSON else {
                closure(.error(NetworkError.wrongContentType)); return
            }
            
            guard let result = try? JSONDecoder().decode([SpeedTestHost].self, from: data) else {
                closure(.error(NetworkError.wrongJSON)); return
            }
            
            closure(.value(result))
        }.resume()
    }
    
    func getHosts(max: Int, timeout: TimeInterval, closure: @escaping (Result<[SpeedTestHost], NetworkError>) -> ()) {
        getHosts(timeout: timeout) { result in
            switch result {
            case .value(let hosts):
                closure(.value(Array(hosts.prefix(max))))
                break
            case .error(let error):
                closure(.error(error))
            }
        }
    }
}
