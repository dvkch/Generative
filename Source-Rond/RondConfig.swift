//
//  RondConfig.swift
//  Rond
//
//  Created by Stanislas Chevallier on 14/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

// TODO: create another config enum for line width + number of lines skipped + alpha -> tatoo
// TODO: rename config

// MARK: Generator
enum RondConfig {
    case singleCircle
    case threeCircles
    case sixteenCircles
    
    var circlesCount: Int {
        switch self {
        case .singleCircle:     return 1
        case .threeCircles:     return 3
        case .sixteenCircles:   return 16
        }
    }
    
    var iterations: Int {
        switch self {
        case .singleCircle:     return 8_000
        case .threeCircles:     return 5_000
        case .sixteenCircles:   return 2_000
        }
    }
}

extension RondConfig : Configurable {
    var description: String {
        switch self {
        case .singleCircle:     return "Single"
        case .threeCircles:     return "x3"
        case .sixteenCircles:   return "x16"
        }
    }
    
    static var all: [RondConfig] {
        return [.singleCircle, .threeCircles, .sixteenCircles]
    }
}
