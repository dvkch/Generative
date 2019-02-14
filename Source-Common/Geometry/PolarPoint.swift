//
//  PolarPoint.swift
//  Generative
//
//  Created by Stanislas Chevallier on 14/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

// MARK: Polar coordinates
struct PolarPoint {
    var theta: CGFloat
    var radius: CGFloat
    
    static func pointsForCircle(radius: CGFloat, count: Int) -> [PolarPoint] {
        let step = CGFloat.pi * 2 / CGFloat(count)
        return (0..<count)
            .map { step * CGFloat($0) + step * Maths.random(max: 1.01, steps: 100, center: true) }
            .map { PolarPoint(theta: $0, radius: radius) }
    }
}

extension PolarPoint : Pointable {
    mutating func moveRandom(startRadius: CGFloat, amplification: CGFloat) {
        let coeffR = Maths.random(max: startRadius / 10_000, steps: 100, center: true) * amplification
        let coeffT = Maths.random(max: startRadius / 50_000, steps: 100, center: true) * amplification
        radius *= (1 + coeffR)
        theta  *= (1 + coeffT)
    }
    
    var cartesianCoordinates: CGPoint {
        return CGPoint(
            x: radius * cos(theta),
            y: radius * sin(theta)
        )
    }
}

