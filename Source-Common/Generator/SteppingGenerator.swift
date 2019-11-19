//
//  SteppingGenerator.swift
//  Rond
//
//  Created by Stanislas Chevallier on 07/08/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

class SteppingGenerator {
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
            for step in 0..<iterations {
                cache[step] = draw(step: step)
            }
        }
    }
    
    // MARK: Drawing
    final func draw(step: Int) -> UIImage? {
        let maxStep = min(step, iterations)
        
        return measureTime(minTime: 1) {
            let drawRect = CGRect(origin: .zero, size: renderSize)
            
            UIGraphicsBeginImageContextWithOptions(drawRect.size, true, renderConfig.scale)
            defer { UIGraphicsEndImageContext() }
            
            colorsConfig.backgroundColor.setFill()
            UIBezierPath(rect: drawRect).fill()
            
            colorsConfig.linesColor.setStroke()
            
            draw(step: step, drawRect: drawRect)

            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
    
    
    func draw(step: Int, drawRect: CGRect) {
        guard UIGraphicsGetCurrentContext() != nil else {
            fatalError("This method should only be called from SteppingGenerator.draw(step:)")
        }
    }
}
