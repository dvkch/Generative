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
    let m: CGFloat
}

extension MassPoint {
    func meanVector(to nearbyPoints: [MassPoint]) -> CGVector {
        let meanMass = nearbyPoints.map({ $0.m }).reduce(0, +)
        if meanMass == 0 {
            return CGVector(dx: 0, dy: 0)
        }
        
        let vectors = nearbyPoints.map { (point) -> CGVector in
            self.vector(to: point) * point.m
        }
        
        // TODO: really need to divide by mean mass?
        return vectors.reduce(CGVector.zero, +) / meanMass
    }
}

extension MassPoint {
    mutating func moveRandom(startRadius: CGFloat, amplification: CGFloat, nearbyPoints: [MassPoint]) {
        let meanVector = self.meanVector(to: nearbyPoints)
        
        let coeffX = Maths.random(max: startRadius / 5_000, steps: 100, center: true) * amplification
        let coeffY = Maths.random(max: startRadius / 5_000, steps: 100, center: true) * amplification
        
        x *= (1 + coeffX)
        y *= (1 + coeffY)
        
        x += meanVector.dx / 500
        y += meanVector.dy / 500
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
