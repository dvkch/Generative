//
//  RondGenerator.swift
//  Rond
//
//  Created by Stanislas Chevallier on 09/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

class RondGenerator : AdditiveGenerator {
    typealias Circles = [Circle]
    typealias Circle = [Pointable]
    
    let rondConfig: RondConfig
    var points = [Circles]()
    
    init(renderSize: CGSize, rondConfig: RondConfig, renderConfig: RenderConfig, colorsConfig: ColorsConfig) {
        self.rondConfig = rondConfig
        super.init(renderSize: renderSize, renderConfig: renderConfig, colorsConfig: colorsConfig)
        
        points.append([])
        for i in 0..<rondConfig.circlesCount {
            points[0].append(PolarPoint.pointsForCircle(radius: startRadius(circle: i), count: 30))
        }
        
        generate()
        generateImageCache()
    }
    
    override var iterations: Int {
        return rondConfig.iterations
    }
    
    private func startRadius(circle: Int) -> CGFloat {
        let factor = CGFloat(circle + 1) / CGFloat(rondConfig.circlesCount)
        return renderSize.min * (0.2 + 0.2 * factor)
    }
    
    override func iterate() {
        let prevCircles = points.last!
        
        points.append([])
        
        for circle in 0..<rondConfig.circlesCount {
            var newPoints = prevCircles[circle]
            
            let radius = startRadius(circle: 0)
            
            for i in 0..<newPoints.count {
                var factor = CGFloat(i + 1) / CGFloat(newPoints.count) // make the points farther from the start move the most
                factor = log(factor + 1) / log(2) // make this amplification not too big
                newPoints[i].moveRandom(startRadius: radius, amplification: factor)
            }
            
            points[points.count - 1].append(newPoints)
        }
    }

    override func draw(step: Int, drawRect: CGRect) {
        super.draw(step: step, drawRect: drawRect)
        
        colorsConfig.linesColor.setStroke()
        
        let path = UIBezierPath()
        path.lineWidth = renderConfig.lineWidth
        for circle in points[step] {
            path.interpolatePointsWithHermite(interpolationPoints: circle.map { $0.cartesianCoordinates })
        }
        path.apply(CGAffineTransform(translationX: drawRect.midX, y: drawRect.midY))
        path.stroke(with: CGBlendMode.normal, alpha: 0.02)
    }
}



