//
//  HostURLFormatter.swift
//  SpeedTestLib
//
//  Created by dhaurylenka on 2/6/18.
//  Copyright © 2018 Exadel. All rights reserved.
//

import Foundation

class HostURLFormatter {
    private let initialUrl: URL
    
    private var downloadURL: URL {
        return initialUrl
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("download")
    }
    
    var uploadURL: URL {
        return initialUrl
    }
    
    init(speedTestURL: URL) {
        initialUrl = speedTestURL
    }
    
    func downloadURL(size: Int) -> URL {
        var urlComponents = URLComponents(url: downloadURL, resolvingAgainstBaseURL: false)!
        urlComponents.port = 8080
        urlComponents.queryItems = [URLQueryItem(name: "size", value: String(size))]
        return urlComponents.url!
    }
}
