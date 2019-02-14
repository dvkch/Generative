//
//  GrilleVC.swift
//  Grille
//
//  Created by Stanislas Chevallier on 10/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

class GrilleVC: UIViewController {
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createGenerator()
    }
    
    // MARK: Views
    @IBOutlet var dotsToggle: UISwitch!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var stepSlider: UISlider!
    @IBOutlet var stepLabel: UILabel!
    
    // MARK: Actions
    @IBAction func dotsToggleChanged() {
        updateImage()
    }
    
    @IBAction func stepChanged() {
        updateImage()
    }
    
    // MARK: Generation
    var generator: GrilleGenerator?
    
    func createGenerator() {
        if generator != nil { return }
        
        generator = GrilleGenerator(
            renderSize: imageView.bounds.size,
            grilleConfig: GrilleConfig.squarre(count: 12),
            renderConfig: RenderConfig.defaultGrille,
            colorsConfig: ColorsConfig.black
        )
        stepSlider.minimumValue = 0
        stepSlider.maximumValue = Float(generator!.grilleConfig.iterations)
        stepChanged()
        
        generator?.colorsConfig.updateAppearance(of: [stepSlider, stepLabel, dotsToggle])
        
        updateImage()
    }
    
    func updateImage() {
        let step = Int(stepSlider.value)
        imageView.image = generator?.draw(until: step, addDots: dotsToggle.isOn)
        stepLabel.text = String(step)
    }
}


