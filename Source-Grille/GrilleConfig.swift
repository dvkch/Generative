//
//  GrilleConfig.swift
//  Grille
//
//  Created by Stanislas Chevallier on 14/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

enum GrilleConfig {
    case squarre(count: Int)
    case rectangle(maxX: Int, maxY: Int)
}

extension GrilleConfig {
    var maxX: Int {
        switch self {
        case .squarre(let count):  return count
        case .rectangle(let x, _): return x
        }
    }
    
    var maxY: Int {
        switch self {
        case .squarre(let count):  return count
        case .rectangle(_, let y): return y
        }
    }
    
    var iterations: Int {
        return 3000
    }
}

extension GrilleConfig : Configurable {
    var description: String {
        switch self {
        case .squarre(let count):  return "Squarre \(count) (\(iterations))"
        case .rectangle(let x, let y):  return "Rectangle \(x)x\(y) (\(iterations))"
        }
    }
    
    static var all: [GrilleConfig] {
        return [
            GrilleConfig.squarre(count: 12),
            GrilleConfig.rectangle(maxX: 5, maxY: 7)
        ]
    }
}

extension GrilleConfig {
    func startPoints(renderSize: CGSize) -> [CGPoint] {
        let xOffset: CGFloat
        let yOffset: CGFloat
        let xSpan: CGFloat
        let ySpan: CGFloat
        
        switch self {
        case .squarre:
            xOffset = renderSize.min * 0.1 + (renderSize.width  - renderSize.min) / 2
            yOffset = renderSize.min * 0.1 + (renderSize.height - renderSize.min) / 2
            xSpan = renderSize.min * 0.8
            ySpan = renderSize.min * 0.8
        case .rectangle:
            xOffset = renderSize.width  * 0.1
            xSpan   = renderSize.width  * 0.8
            yOffset = renderSize.height * 0.1
            ySpan   = renderSize.height * 0.8
        }
        
        
        let Xs = (0..<maxX)
            .map { i -> CGFloat in CGFloat(i + 1) / CGFloat(maxX + 1) }
            .map { p -> CGFloat in xOffset + xSpan * p }
        
        let Ys = (0..<maxY)
            .map { i -> CGFloat in CGFloat(i + 1) / CGFloat(maxY + 1) }
            .map { p -> CGFloat in yOffset + ySpan * p }
        
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

extension GrilleConfig {
    private struct Path {
        let x: Int
        let y: Int
    }
    
    private func pathFromIndex(_ index: Int) -> Path {
        return Path(x: index % maxX, y: index / maxX)
    }
    
    private func indexFromPath(_ path: Path) -> Int {
        return path.y * maxX + path.x
    }
    
    func indicesNear(index: Int) -> [Int] {
        let path = pathFromIndex(index)
        
        var indices = [Int]()
        if path.x > 0 {
            indices.append(indexFromPath(Path(x: path.x - 1, y: path.y)))
        }
        
        if path.y > 0 {
            indices.append(indexFromPath(Path(x: path.x, y: path.y - 1)))
        }
        
        if path.x < maxX - 1 {
            indices.append(indexFromPath(Path(x: path.x + 1, y: path.y)))
        }
        
        if path.y < maxY - 1 {
            indices.append(indexFromPath(Path(x: path.x, y: path.y + 1)))
        }
        
        if path.x > 0 && path.y > 0 {
            indices.append(indexFromPath(Path(x: path.x - 1, y: path.y - 1)))
        }
        
        if path.x < maxX - 1 && path.y < maxY - 1 {
            indices.append(indexFromPath(Path(x: path.x + 1, y: path.y + 1)))
        }
        
        if path.x > 0 && path.y < maxY - 1 {
            indices.append(indexFromPath(Path(x: path.x - 1, y: path.y + 1)))
        }
        
        if path.x < maxX - 1 && path.y > 0 {
            indices.append(indexFromPath(Path(x: path.x + 1, y: path.y - 1)))
        }
        
        return indices
    }
}

extension GrilleConfig {
    static func testNearbyPoints() {
        let config = GrilleConfig.squarre(count: 3)
        /*
         *  0  1  2
         *  3  4  5
         *  6  7  8
         */
        
        assert(config.indicesNear(index: 0).sorted() == [1, 3, 4].sorted())
        assert(config.indicesNear(index: 1).sorted() == [0, 2, 3, 4, 5].sorted())
        assert(config.indicesNear(index: 2).sorted() == [1, 4, 5].sorted())
        assert(config.indicesNear(index: 3).sorted() == [0, 1, 4, 7, 6].sorted())
        assert(config.indicesNear(index: 4).sorted() == [0, 1, 2, 3, 5, 6, 7, 8].sorted())
        assert(config.indicesNear(index: 5).sorted() == [2, 1, 4, 7, 8].sorted())
        assert(config.indicesNear(index: 6).sorted() == [3, 4, 7].sorted())
        assert(config.indicesNear(index: 7).sorted() == [6, 3, 4, 5, 8].sorted())
        assert(config.indicesNear(index: 8).sorted() == [5, 4, 7].sorted())
        
        print("All good")
    }
}
