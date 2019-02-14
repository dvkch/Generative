//
//  CGPoint+SY.swift
//  Rond
//
//  Created by Stanislas Chevallier on 09/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

extension CGPoint: Pointable {
    
    mutating func moveRandom(startRadius: CGFloat, amplification: CGFloat) {
        let coeffX = Maths.random(max: startRadius / 5_000, steps: 100, center: true) * amplification
        let coeffY = Maths.random(max: startRadius / 5_000, steps: 100, center: true) * amplification

        x *= (1 + coeffX)
        y *= (1 + coeffY)
    }
    
    var cartesianCoordinates: CGPoint {
        return self
    }
}

