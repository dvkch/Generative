//
//  Pointable.swift
//  Generative
//
//  Created by Stanislas Chevallier on 14/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

protocol Pointable {
    var cartesianCoordinates: CGPoint { get }
    mutating func moveRandom(startRadius: CGFloat, amplification: CGFloat)
}

extension Array where Element : Pointable {
    var cartesianCoordinates: [CGPoint] {
        return self.map { $0.cartesianCoordinates }
    }
}

extension Pointable {
    func vector(to point: Pointable) -> CGVector {
        return CGVector(
            dx: point.cartesianCoordinates.x - cartesianCoordinates.x,
            dy: point.cartesianCoordinates.y - cartesianCoordinates.y
        )
    }
}
