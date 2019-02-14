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
        generator = GridGenerator(
            renderSize: imageView.bounds.size,
            gridConfig: GridConfig.default,
            drawingConfig: DrawingConfig.default
        )
        stepSlider.minimumValue = 0
        stepSlider.maximumValue = Float(generator.gridConfig.iterations)
        stepChanged()
    }

    // MARK: Views
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var stepSlider: UISlider!
    @IBOutlet var stepLabel: UILabel!

    // MARK: Generation
    var generator: GridGenerator!
    
    @IBAction func stepChanged() {
        let step = Int(stepSlider.value)
        imageView.image = generator.draw(atStep: step)
        stepLabel.text = String(step)
    }
}

