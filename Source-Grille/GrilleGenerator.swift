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
        // Maths.random(max: 4, steps: 20, center: true)
        
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
        
        let dimension = min(
            renderSize.width  / CGFloat(grilleConfig.maxX),
            renderSize.height / CGFloat(grilleConfig.maxY)
        )
        
        for i in 0..<newPoints.count {
            let nearby = grilleConfig
                .indicesNear(index: i)
                .map { prevPoints[$0] }
            
            newPoints[i].moveRandom(startRadius: dimension, amplification: 0.5, nearbyPoints: nearby)
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
        
        for point in stepPoints {
            let color = point.m > 0 ? UIColor.yellow : .red
            color.setFill()
            
            let path = UIBezierPath()
            path.move(to: point.cartesianCoordinates)
            path.addArc(withCenter: point.cartesianCoordinates, radius: (point.m + 1) * 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            path.fill()
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
