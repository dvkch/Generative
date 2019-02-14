//
//  AdditiveGenerator.swift
//  Generative
//
//  Created by Stanislas Chevallier on 14/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

class AdditiveGenerator {
    // MARK: Init
    init(renderSize: CGSize, renderConfig: RenderConfig, colorsConfig: ColorsConfig) {
        self.renderSize = renderSize
        self.renderConfig = renderConfig
        self.colorsConfig = colorsConfig
        // when subclassing call generate() and generateImageCache() after super.init()
    }
    
    // MARK: Properties
    let renderSize: CGSize
    let renderConfig: RenderConfig
    let colorsConfig: ColorsConfig
    
    // MARK: Properties to override
    var iterations: Int {
        fatalError("You should override this")
    }
    
    // MARK: Generation
    final func generate() {
        measureTime {
            for _ in 0..<iterations {
                iterate()
            }
        }
    }
    
    func iterate() {
        
    }
    
    // MARK: Image cache
    var cache = [Int: UIImage]()
    final func generateImageCache() {
        measureTime {
            for step in stride(from: 0, to: iterations, by: iterations / 20) {
                cache[step] = draw(until: step)
            }
        }
    }
    
    // MARK: Drawing
    final func draw(until step: Int) -> UIImage? {
        let prevStep = cache.keys.filter({ $0 < step }).max() ?? 0
        var prevImage = cache[prevStep]
        
        let maxStep = min(step, iterations)
        
        return measureTime(minTime: 1) {
            let drawRect = CGRect(origin: .zero, size: renderSize)
            
            UIGraphicsBeginImageContextWithOptions(drawRect.size, true, renderConfig.scale)
            defer { UIGraphicsEndImageContext() }
            
            if let prevImage = prevImage {
                prevImage.draw(in: drawRect)
            }
            else {
                colorsConfig.backgroundColor.setFill()
                UIBezierPath(rect: drawRect).fill()
            }
            
            colorsConfig.linesColor.setStroke()
            
            for step in stride(from: prevStep, to: maxStep, by: renderConfig.drawEveryNStep) {
                draw(step: step, drawRect: drawRect)
            }
            
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
    
    
    func draw(step: Int, drawRect: CGRect) {
        guard UIGraphicsGetCurrentContext() != nil else {
            fatalError("This method should only be called from AdditiveGenerator.draw(until:)")
        }
    }
}
