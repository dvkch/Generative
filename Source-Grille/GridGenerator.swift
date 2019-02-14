//
//  GridGenerator.swift
//  Grille
//
//  Created by Stanislas Chevallier on 10/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

struct DrawingConfig {
    let lineWidth: CGFloat
    let scale: CGFloat
    let linesColor: UIColor
    let backgroundColor: UIColor
    
    static var `default`: DrawingConfig {
        return DrawingConfig(lineWidth: 1, scale: 2, linesColor: UIColor(white: 0, alpha: 0.02), backgroundColor: .white)
    }
}

class GridGenerator {
    let gridConfig: GridConfig
    let drawingConfig: DrawingConfig
    let renderSize: CGSize
    let segmentsIndices: [(Int, Int)]

    typealias Grid = [CGPoint]
    var steps = [Grid]()
    
    init(renderSize: CGSize, gridConfig: GridConfig, drawingConfig: DrawingConfig) {
        self.renderSize = renderSize
        self.gridConfig = gridConfig
        self.drawingConfig = drawingConfig
        self.segmentsIndices = gridConfig.segmentsIndices()
        
        generate()
    }

    private func generate() {
        steps = [gridConfig.startPoints(renderSize: renderSize)]
        for _ in 0..<gridConfig.iterations {
            iterate()
        }
    }
    
    private func iterate() {
        var newPoints = steps.last!
        
        for i in 0..<newPoints.count {
            newPoints[i].randomWalk()
        }
        
        steps.append(newPoints)
    }
    
    func draw(atStep maxStep: Int) -> UIImage? {
        
        let drawRect = CGRect(origin: .zero, size: renderSize)
        
        UIGraphicsBeginImageContextWithOptions(renderSize, false, drawingConfig.scale)
        defer { UIGraphicsEndImageContext() }
        
        drawingConfig.backgroundColor.setFill()
        UIBezierPath(rect: drawRect).fill()
        
        drawingConfig.linesColor.setStroke()

        for step in 0..<min(maxStep, steps.count) {
            let path = UIBezierPath()
            path.lineWidth = drawingConfig.lineWidth
            
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
            
            path.stroke(with: CGBlendMode.normal, alpha: 1)
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
