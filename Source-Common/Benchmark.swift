//
//  Benchmark.swift
//  Rond
//
//  Created by Stanislas Chevallier on 09/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

func measureTime<T>(minTime: TimeInterval = 0, funName: String = #function, _ block: () -> T) -> T {
    let d = Date()
    let result = block()
    let t = Date().timeIntervalSince(d)
    if t > minTime {
        print(funName, t)
    }
    return result
}
