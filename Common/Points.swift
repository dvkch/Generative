//
//  Points.swift
//  Rond
//
//  Created by Stanislas Chevallier on 09/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

// MARK: Protocol
protocol Movable {
    mutating func moveRandom(startRadius: CGFloat, amplification: CGFloat)
    var cartesianPoint: CGPoint { get }
}

extension Array where Element : Movable {
    var cartesianPoints: [CGPoint] {
        return self.map { $0.cartesianPoint }
    }
}

// MARK: CGPoint
extension CGPoint: Movable {
    // TODO: cleanup
    mutating func randomWalk() {
        x *= 1 + Maths.random(max: 0.01, steps: 100, center: true)
        y *= 1 + Maths.random(max: 0.01, steps: 100, center: true)
    }
    
    mutating func moveRandom(startRadius: CGFloat, amplification: CGFloat) {
        let coeffX = Maths.random(max: startRadius / 5_000, steps: 100, center: true) * amplification
        let coeffY = Maths.random(max: startRadius / 5_000, steps: 100, center: true) * amplification

        x *= (1 + coeffX)
        y *= (1 + coeffY)
    }
    
    var cartesianPoint: CGPoint {
        return self
    }
}

extension CGPoint {
    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

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

extension PolarPoint : Movable {
    mutating func moveRandom(startRadius: CGFloat, amplification: CGFloat) {
        let coeffR = Maths.random(max: startRadius / 10_000, steps: 100, center: true) * amplification
        let coeffT = Maths.random(max: startRadius / 50_000, steps: 100, center: true) * amplification
        radius *= (1 + coeffR)
        theta  *= (1 + coeffT)
    }

    var cartesianPoint: CGPoint {
        return CGPoint.init(
            x: radius * cos(theta),
            y: radius * sin(theta)
        )
    }
}

