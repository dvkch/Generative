//
//  Generator.swift
//  Rond
//
//  Created by Stanislas Chevallier on 09/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit



class CircleGenerator {
    typealias Circles = [Circle]
    typealias Circle = [Movable]
    
    let renderSize: CGSize
    let config: CircleGeneratorConfig
    let colors: DrawingConfig
    
    var points = [Circles]()
    var cache = [Int: UIImage]()
    
    required init(renderSize: CGSize, config: CircleGeneratorConfig, colors: DrawingConfig) {
        self.renderSize = renderSize
        self.config = config
        self.colors = colors
        
        points.append([])
        for i in 0..<config.circlesCount {
            points[0].append(PolarPoint.pointsForCircle(radius: startRadius(circle: i), count: 30))
        }
        
        generate()
        generateImageCache()
    }
    
    private func startRadius(circle: Int) -> CGFloat {
        let factor = CGFloat(circle + 1) / CGFloat(config.circlesCount)
        return renderSize.min * (0.2 + 0.2 * factor)
    }
    
    private func generate() {
        measureTime {
            for _ in 0..<config.iterations {
                iterate()
            }
        }
    }
    
    private func generateImageCache() {
        measureTime {
            for steps in stride(from: 0, to: config.iterations, by: config.iterations / config.imageCacheCount) {
                guard let image = draw(step: steps) else { return }
                cache[steps] = image
            }
        }
    }
    
    private func iterate() {
        let prevCircles = points.last!
        
        points.append([])
        
        for circle in 0..<config.circlesCount {
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

    func draw(step: Int) -> UIImage? {
        
        let prevStep = cache.keys.filter({ $0 < step }).max() ?? 0
        var prevImage = cache[prevStep]
        
        let maxStep = min(step, config.iterations)
        
        return measureTime(minTime: 1) {
            let drawRect = CGRect(origin: .zero, size: renderSize)
            
            UIGraphicsBeginImageContextWithOptions(drawRect.size, true, config.scale)
            defer { UIGraphicsEndImageContext() }
            
            if let prevImage = prevImage {
                prevImage.draw(in: drawRect)
            }
            else {
                colors.backgroundColor.setFill()
                UIBezierPath(rect: drawRect).fill()
            }

            colors.linesColor.setStroke()
            
            for step in stride(from: prevStep, to: maxStep, by: config.drawingSkippedSteps) {
                let path = UIBezierPath()
                path.lineWidth = config.lineWidth
                for circle in points[step] {
                    path.interpolatePointsWithHermite(interpolationPoints: circle.map { $0.cartesianPoint })
                }
                path.apply(CGAffineTransform(translationX: drawRect.midX, y: drawRect.midY))
                path.stroke(with: CGBlendMode.normal, alpha: 0.02)
            }

            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
}



