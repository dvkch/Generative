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

    typealias Grid = [CGPoint]
    var steps = [Grid]()
    
    init(renderSize: CGSize, grilleConfig: GrilleConfig, renderConfig: RenderConfig, colorsConfig: ColorsConfig) {
        self.grilleConfig = grilleConfig
        self.segmentsIndices = grilleConfig.segmentsIndices()
        super.init(renderSize: renderSize, renderConfig: renderConfig, colorsConfig: colorsConfig)
        
        steps = [grilleConfig.startPoints(renderSize: renderSize)]

        generate()
        generateImageCache()
    }

    override var iterations: Int {
        return grilleConfig.iterations
    }
    
    override func iterate() {
        var newPoints = steps.last!
        
        let dimension = min(renderSize.width / CGFloat(grilleConfig.maxX), renderSize.height / CGFloat(grilleConfig.maxY))
        
        for i in 0..<newPoints.count {
            newPoints[i].moveRandom(startRadius: dimension, amplification: 0.5)
        }
        
        steps.append(newPoints)
    }
    
    override func draw(step: Int, drawRect: CGRect) {
        super.draw(step: step, drawRect: drawRect)
        
        colorsConfig.linesColor.setStroke()
        
        let path = UIBezierPath()
        path.lineWidth = renderConfig.lineWidth
        
        let stepPoints = steps[step]
        /*
         for point in steps[step] {
         path.move(to: point)
         path.addArc(withCenter: point, radius: 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
         }*/
        
        for indices in segmentsIndices {
            path.move(to: stepPoints[indices.0])
            path.addLine(to: stepPoints[indices.1])
        }
        
        path.stroke(with: CGBlendMode.normal, alpha: renderConfig.lineAlpha)
    }
}
