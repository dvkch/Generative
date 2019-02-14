//
//  Configs.swift
//  Rond
//
//  Created by Stanislas Chevallier on 14/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

// TODO: create another config enum for line width + number of lines skipped + alpha -> tatoo

// MARK: Generator
enum CircleGeneratorConfig {
    case singleCircle
    case threeCircles
    case sixteenCircles
    
    var scale: CGFloat {
        return 2
    }
    
    var lineWidth: CGFloat {
        return 1 / scale
    }
    
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
    
    var imageCacheCount: Int {
        return 20
    }
    
    var drawingSkippedSteps: Int {
        if self == .singleCircle { return 1 }
        return 3
    }
}

extension CircleGeneratorConfig : Configurable {
    var description: String {
        switch self {
        case .singleCircle:     return "Single"
        case .threeCircles:     return "x3"
        case .sixteenCircles:   return "x16"
        }
    }
    
    static var all: [CircleGeneratorConfig] {
        return [.singleCircle, .threeCircles, .sixteenCircles]
    }
}

// MARK: Drawing
enum DrawingConfig {
    case darkBlue
    case black
    case orange
    
    var linesColor: UIColor {
        switch self {
        case .darkBlue, .black: return UIColor.white
        case .orange:           return UIColor.orange
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .darkBlue: return UIColor(red: 41/255, green: 76/255, blue: 92/255, alpha: 1)
        case .black:    return UIColor.black
        case .orange:   return UIColor.white
        }
    }
}

extension DrawingConfig : Configurable {
    var description: String {
        switch self {
        case .darkBlue: return "darkBlue"
        case .black:    return "black"
        case .orange:   return "orange"
        }
    }
    
    static var all: [DrawingConfig] {
        return [.darkBlue, .black, .orange]
    }
}
