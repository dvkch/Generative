//
//  GrilleConfig.swift
//  Grille
//
//  Created by Stanislas Chevallier on 14/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

struct GrilleConfig {
    let maxX: Int
    let maxY: Int
    let iterations: Int
    
    static var `default`: GrilleConfig {
        return GrilleConfig(maxX: 5, maxY: 10, iterations: 1000)
    }
}

extension GrilleConfig : Configurable {
    var description: String {
        return String(maxX) + "x" + String(maxY) + " (" + String(iterations) + ")"
    }
    
    static var all: [GrilleConfig] {
        return [GrilleConfig.default]
    }
}

extension GrilleConfig {
    func startPoints(renderSize: CGSize) -> [CGPoint] {
        let Xs = (0..<maxX)
            .map { i -> CGFloat in CGFloat(i + 1) / CGFloat(maxX + 1) }
            .map { p -> CGFloat in renderSize.width * (0.1 + p * 0.8) }
        
        let Ys = (0..<maxY)
            .map { i -> CGFloat in CGFloat(i + 1) / CGFloat(maxY + 1) }
            .map { p -> CGFloat in renderSize.height * (0.1 + p * 0.8) }
        
        return Ys.map { y -> [CGPoint] in
            Xs.map { x -> CGPoint in
                return CGPoint(x: x, y: y)
            }
            }.reduce([], +)
    }
    
    func segmentsIndices() -> [(Int, Int)] {
        var indices = [(Int, Int)]()
        
        // horizontal segments
        for y in 0..<maxY {
            for x in 0..<(maxX - 1) {
                let i0 = y * maxX + x
                let i1 = y * maxX + x + 1
                indices.append((i0, i1))
            }
        }
        
        // vertical segments
        for x in 0..<maxX {
            for y in 0..<(maxY - 1) {
                let i0 = (y + 0) * maxX + x
                let i1 = (y + 1) * maxX + x
                indices.append((i0, i1))
            }
        }
        
        return indices
    }
}
