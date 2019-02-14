//
//  RenderConfig.swift
//  Generative
//
//  Created by Stanislas Chevallier on 14/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

struct RenderConfig {
    let lineWidth: CGFloat
    let lineAlpha: CGFloat
    let scale: CGFloat
    let skippedSteps: Int
    
    static var defaultGrille: RenderConfig {
        return RenderConfig(lineWidth: 0.5, lineAlpha: 0.02, scale: 2, skippedSteps: 1)
    }
    
    static var defaultRond: RenderConfig {
        return RenderConfig(lineWidth: 0.5, lineAlpha: 0.02, scale: 2, skippedSteps: 3)
    }
}

extension RenderConfig : Configurable {
    var description: String {
        return "\(lineWidth)pt, α=\(lineAlpha), @\(scale)x, skip \(skippedSteps)"
    }
    
    static var all: [RenderConfig] {
        return [RenderConfig.defaultGrille, RenderConfig.defaultRond]
    }
}
