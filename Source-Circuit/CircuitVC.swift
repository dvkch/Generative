//
//  CircuitVC.swift
//  Circuit
//
//  Created by Stanislas Chevallier on 07/08/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

class CircuitVC: UIViewController {

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createGenerator(reset: false)
    }
    
    // MARK: Views
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var stepSlider: UISlider!
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var resetButton: UIButton!

    // MARK: Actions
    @IBAction func stepChanged() {
        updateImage()
    }
    
    @IBAction func resetButtonTap() {
        createGenerator(reset: true)
    }
    
    // MARK: Generation
    var generator: CircuitGenerator?
    
    func createGenerator(reset: Bool) {
        if generator != nil && !reset { return }
        
        generator = CircuitGenerator(
            renderSize: imageView.bounds.size,
            circuitConfig: CircuitConfig.main,
            renderConfig: RenderConfig.defaultGrille,
            colorsConfig: ColorsConfig.black
        )
        stepSlider.minimumValue = 0
        stepSlider.maximumValue = Float(generator!.circuitConfig.iterations)
        stepChanged()
        
        generator?.colorsConfig.updateAppearance(of: [stepSlider, stepLabel, resetButton])
        
        updateImage()
    }
    
    func updateImage() {
        let step = Int(stepSlider.value)
        imageView.image = generator?.draw(step: step)
        stepLabel.text = String(step)
    }
}


