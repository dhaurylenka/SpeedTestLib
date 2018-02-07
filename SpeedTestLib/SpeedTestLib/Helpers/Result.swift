//
//  Result.swift
//  SpeedTestLib
//
//  Created by dhaurylenka on 2/5/18.
//  Copyright © 2018 Exadel. All rights reserved.
//

import Foundation

public enum Result<T, E: Error> {
    case value(T)
    case error(E)
}
