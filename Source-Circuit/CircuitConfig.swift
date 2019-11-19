//
//  CircuitConfig.swift
//  Circuit
//
//  Created by Stanislas Chevallier on 07/08/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

// MARK: Generator
enum CircuitConfig {
    case main
    
    var iterations: Int {
        return 20
    }
}

extension CircuitConfig : Configurable {
    var description: String {
        switch self {
        case .main:     return "main"
        }
    }
    
    static var all: [CircuitConfig] {
        return [.main]
    }
}

