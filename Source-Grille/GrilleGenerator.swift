//
//  GrilleGenerator.swift
//  Grille
//
//  Created by Stanislas Chevallier on 10/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

class GrilleGenerator : AdditiveGenerator {
    let grilleConfig: GrilleConfig
    let segmentsIndices: [(Int, Int)]

    typealias Grid = [MassPoint]
    var steps = [Grid]()
    
    init(renderSize: CGSize, grilleConfig: GrilleConfig, renderConfig: RenderConfig, colorsConfig: ColorsConfig) {
        self.grilleConfig = grilleConfig
        self.segmentsIndices = grilleConfig.segmentsIndices()
        super.init(renderSize: renderSize, renderConfig: renderConfig, colorsConfig: colorsConfig)
        
        let masses = [CGFloat(1), 2, -1, -2]
        
        let firstPoints = grilleConfig
            .startPoints(renderSize: renderSize)
            .map { $0.massPoint(mass: masses.randomElement()!) }
        
        steps = [firstPoints]

        generate()
        generateImageCache()
    }

    override var iterations: Int {
        return grilleConfig.iterations
    }
    
    override func iterate() {
        let prevPoints = steps.last!
        var newPoints = prevPoints
        
        let dimension = renderSize.min / 5
        
        for i in 0..<newPoints.count {
            let nearby = grilleConfig
                .indicesNear(index: i)
                .map { prevPoints[$0] }
            
            newPoints[i].moveRandom(startRadius: dimension, amplification: 0.1, nearbyPoints: nearby)
        }
        
        steps.append(newPoints)
    }
    
    func draw(until maxStep: Int, addDots: Bool) -> UIImage? {
        guard let baseImage = self.draw(until: maxStep) else { return nil }
        guard addDots else { return baseImage }
        
        UIGraphicsBeginImageContextWithOptions(baseImage.size, true, baseImage.scale)
        defer { UIGraphicsEndImageContext() }
        
        baseImage.draw(at: .zero)
        
        let stepPoints = steps[min(maxStep, iterations)]
        
        for (i, point) in stepPoints.enumerated() {
            let closed = point.m > 0

            let arc = UIBezierPath()
            arc.lineWidth = 2
            arc.addArc(withCenter: point.cartesianCoordinates, radius: (abs(point.m) + 1) * 3, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            if closed {
                colorsConfig.linesColor.setFill()
                arc.fill()
            } else {
                colorsConfig.linesColor.setStroke()
                arc.stroke()
            }
            
            let nearby = grilleConfig
                .indicesNear(index: i)
                .map { stepPoints[$0] }
            let v = point.vectorToCentroid(of: nearby, applyDirection: true)
            
            let vector = UIBezierPath()
            vector.move(to: point.cartesianCoordinates)
            vector.addLine(to: CGPoint(x: point.x + v.dx, y: point.y + v.dy))
            vector.lineWidth = 2
            UIColor(red: 0, green: 0.5, blue: 1, alpha: 1).setStroke()
            vector.stroke()
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    override func draw(step: Int, drawRect: CGRect) {
        super.draw(step: step, drawRect: drawRect)
        
        colorsConfig.linesColor.setStroke()
        
        let path = UIBezierPath()
        path.lineWidth = renderConfig.lineWidth
        
        let stepPoints = steps[step]
        for indices in segmentsIndices {
            path.move(to: stepPoints[indices.0].cartesianCoordinates)
            path.addLine(to: stepPoints[indices.1].cartesianCoordinates)
        }
        
        path.stroke(with: CGBlendMode.normal, alpha: renderConfig.lineAlpha)
    }
}
