//
//  ViewController.swift
//  Grille
//
//  Created by Stanislas Chevallier on 10/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        generator = GrilleGenerator(
            renderSize: imageView.bounds.size,
            grilleConfig: GrilleConfig.default,
            renderConfig: RenderConfig.defaultGrille,
            colorsConfig: ColorsConfig.black
        )
        stepSlider.minimumValue = 0
        stepSlider.maximumValue = Float(generator.grilleConfig.iterations)
        stepChanged()
        
        generator.colorsConfig.updateAppearance(of: [stepSlider, stepLabel])
    }

    // MARK: Views
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var stepSlider: UISlider!
    @IBOutlet var stepLabel: UILabel!

    // MARK: Generation
    var generator: GrilleGenerator!
    
    @IBAction func stepChanged() {
        let step = Int(stepSlider.value)
        imageView.image = generator.draw(until: step)
        stepLabel.text = String(step)
    }
}

