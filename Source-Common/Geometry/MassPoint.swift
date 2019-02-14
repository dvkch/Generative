//
//  MassPoint.swift
//  Generative
//
//  Created by Stanislas Chevallier on 14/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

struct MassPoint {
    var x: CGFloat
    var y: CGFloat
    let m: CGFloat // m is positive for a closed node (moving towards the centroid of nearby points), negative for an open node (moving away)
}

extension Array where Element == MassPoint {
    var centroid: CGPoint {
        let meanMass = map({ abs($0.m) }).reduce(0, +)
        
        let center = self
            .map { $0.cartesianCoordinates * abs($0.m) / meanMass }
            .reduce(.zero, +)
        
        return center
    }
}

extension MassPoint {
    func vectorToCentroid(of points: [MassPoint], applyDirection: Bool) -> CGVector {
        let centroid = points.centroid
        let vector = CGVector(dx: centroid.x - x, dy: centroid.y - y)
        
        if applyDirection {
            // 1 if positive, -1 if negative
            return vector * m / abs(m)
        }
        return vector
    }
}

extension MassPoint {
    mutating func moveRandom(startRadius: CGFloat, amplification: CGFloat, nearbyPoints: [MassPoint]) {
        let meanVector = vectorToCentroid(of: nearbyPoints, applyDirection: true)
        
        let coeffX  = Maths.random(max: startRadius / 5_000, steps: 100, center: true) * amplification
        let coeffY  = Maths.random(max: startRadius / 5_000, steps: 100, center: true) * amplification
        
        x = x * (1 + coeffX) + meanVector.dx / 200 * amplification
        y = y * (1 + coeffY) + meanVector.dy / 200 * amplification
    }
}

extension MassPoint : Pointable {
    var cartesianCoordinates: CGPoint {
        return CGPoint(x: x, y: y)
    }
    
    mutating func moveRandom(startRadius: CGFloat, amplification: CGFloat) {
        let coeffX = Maths.random(max: startRadius / 5_000, steps: 100, center: true) * amplification
        let coeffY = Maths.random(max: startRadius / 5_000, steps: 100, center: true) * amplification
        
        x *= (1 + coeffX)
        y *= (1 + coeffY)
    }
}

extension CGPoint {
    func massPoint(mass: CGFloat) -> MassPoint {
        return MassPoint(x: x, y: y, m: mass)
    }
    
    var massPointWithRandomMass: MassPoint {
        return MassPoint(x: x, y: y, m: Maths.random(max: 2, steps: 10, center: true))
    }
}
