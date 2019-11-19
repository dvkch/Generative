//
//  CircuitGenerator.swift
//  Rond
//
//  Created by Stanislas Chevallier on 07/08/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

class CircuitGenerator : SteppingGenerator {
    let circuitConfig: CircuitConfig

    init(renderSize: CGSize, circuitConfig: CircuitConfig, renderConfig: RenderConfig, colorsConfig: ColorsConfig) {
        self.circuitConfig = circuitConfig
        super.init(renderSize: renderSize, renderConfig: renderConfig, colorsConfig: colorsConfig)
        
        steps.append(([], []))
        
        generate()
        generateImageCache()
    }
    
    private typealias Step = ([Dot], [Connection])
    private var steps = [Step]()

    override var iterations: Int {
        return circuitConfig.iterations
    }
    
    override func iterate() {
        let prevStep = steps.last!
        var dots = prevStep.0
        var connections = prevStep.1

        // sometimes connect single dots
        let singleDots = findSingleDots(dots: dots, connections: connections)
        for singleDot in singleDots {
            if arc4random_uniform(2) == 0 { continue }
            guard let otherDot = dots.filter({ $0 != singleDot }).randomElement() else { continue }
            connections.append(Connection(singleDot, otherDot))
        }
        
        // sometimes add random dots
        while arc4random_uniform(2) == 0 {
            let x = CGFloat.random(in: 0..<renderSize.width)
            let y = CGFloat.random(in: 0..<renderSize.height)
            let isBig = arc4random_uniform(3) > 0
            dots.append(Dot(origin: CGPoint(x: x, y: y), isBig: isBig))
        }
        
        steps.append((dots, connections))
    }
    
    override func draw(step: Int, drawRect: CGRect) {
        super.draw(step: step, drawRect: drawRect)
        
        let dots = steps[step].0
        let connections = steps[step].1
        
        let bigDotSize = CGSize(width: 5, height: 10)
        let smallDotSize = CGSize(width: 3, height: 6)

        colorsConfig.linesColor.setFill()
        for dot in dots {
            let size = dot.isBig ? bigDotSize : smallDotSize
            UIBezierPath(rect: CGRect(origin: dot.origin, size: size)).fill()
        }
        
        for connection in connections {
            drawConnection(connection)
        }
    }
    
    private func drawConnection(_ connection: Connection) {
        let angle = 80 * CGFloat.pi / 180
        
        var points: [CGPoint]
        
        switch connection.axis {
        case .horizontal:
            /*
             *   x--------x
             *             \
             *              \
             *               x---------x
             */

            
            let deltaY = connection.height
            let diagonaleXSpan = abs(sin(angle + .pi) * deltaY)
            
            let pStart = connection.x1 < connection.x2 ? connection.dot1.origin : connection.dot2.origin
            let pEnd   = connection.x1 < connection.x2 ? connection.dot2.origin : connection.dot1.origin
            let p1 = CGPoint(x: connection.xMid - diagonaleXSpan / 2, y: pStart.y)
            let p2 = CGPoint(x: connection.xMid + diagonaleXSpan / 2, y: pEnd.y)
            points = [pStart, p1, p2, pEnd]
            
        case .vertical:
            /*
             *   x
             *   |
             *   x
             *    \
             *     \
             *      \
             *       x
             *       |
             *       x
             */

            
            let deltaX = connection.width
            let diagonaleYSpan = abs(sin(angle) * deltaX)
            
            let pStart = connection.y1 < connection.y2 ? connection.dot1.origin : connection.dot2.origin
            let pEnd   = connection.y1 < connection.y2 ? connection.dot2.origin : connection.dot1.origin
            let p1 = CGPoint(x: pStart.x, y: connection.yMid - diagonaleYSpan / 2)
            let p2 = CGPoint(x: pEnd.x,   y: connection.yMid + diagonaleYSpan / 2)
            points = [pStart, p1, p2, pEnd]
        }
        
        let linesPath = UIBezierPath()
        linesPath.lineWidth = renderConfig.lineWidth
        linesPath.move(to: points.first!)
        for p in points.dropFirst() {
            linesPath.addLine(to: p)
        }
        colorsConfig.linesColor.setStroke()
        linesPath.stroke()
    }
}

private extension CircuitGenerator {
    struct Dot : Equatable {
        let id = UUID().uuidString
        let origin: CGPoint
        let isBig: Bool
        
        static func ==(lhs: Dot, rhs: Dot) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    struct Connection {
        let dot1: Dot
        let dot2: Dot
        
        private let rect: CGRect
        
        init(_ d1: Dot, _ d2: Dot) {
            dot1 = d1.origin.x < d2.origin.x ? d1 : d2
            dot2 = d1.origin.x < d2.origin.x ? d2 : d1
            rect = CGRect(x: d1.origin.x, y: d1.origin.y, width: d2.origin.x - d1.origin.x, height: d2.origin.y - d1.origin.y)
        }
        
        var axis: NSLayoutConstraint.Axis {
            return rect.width > rect.height ? .horizontal : .vertical
        }
        
        var x1: CGFloat     { return dot1.origin.x }
        var y1: CGFloat     { return dot1.origin.y }
        var y2: CGFloat     { return dot2.origin.y }
        var x2: CGFloat     { return dot2.origin.x }
        var xMid: CGFloat   { return rect.midX }
        var yMid: CGFloat   { return rect.midY }
        var width: CGFloat  { return rect.width }
        var height: CGFloat { return rect.height }
    }
    
    func findSingleDots(dots: [Dot], connections: [Connection]) -> [Dot] {
        var result = dots
        for conn in connections {
            result.removeAll(where: { conn.dot1 == $0 || conn.dot2 == $0 })
        }
        return result
    }
}
