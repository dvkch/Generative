//
//  ViewController.swift
//  Rond
//
//  Created by Stanislas Chevallier on 09/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        segmentsConfigs.updateWithConfigurable(configurable: RondConfig.self)
        segmentsColors.updateWithConfigurable(configurable: ColorsConfig.self)

        stepSlider.maximumTrackTintColor = .gray
        hqButton.layer.cornerRadius = 5
        hqButton.layer.masksToBounds = true
        
        updateGenerators()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: Generation
    var generator: RondGenerator?
    
    // MARK: Views
    @IBOutlet var segmentsConfigs: UISegmentedControl!
    @IBOutlet var segmentsColors: UISegmentedControl!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var stepSlider: UISlider!
    @IBOutlet var hqButton: UIButton!

    // MARK: Configs
    private func updateGenerators() {
        generator = nil
        updateImageAndStepper()
        
        let config = RondConfig.all[self.segmentsConfigs.selectedSegmentIndex]
        let colors = ColorsConfig.all[self.segmentsColors.selectedSegmentIndex]
        
        view.backgroundColor = colors.backgroundColor
        segmentsConfigs.tintColor = colors.linesColor
        segmentsColors.tintColor = colors.linesColor
        stepSlider.minimumTrackTintColor = colors.linesColor
        stepLabel.textColor = colors.linesColor
        hqButton.setTitleColor(colors.backgroundColor, for: .normal)
        hqButton.backgroundColor = colors.linesColor

        SVProgressHUD.show()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.generator = RondGenerator(
                renderSize: self.imageView.bounds.size,
                rondConfig: config,
                renderConfig: RenderConfig.defaultRond,
                colorsConfig: colors
            )
            
            self.stepSlider.minimumValue = 0
            self.stepSlider.maximumValue = Float(self.generator!.rondConfig.iterations) - 1
            
            self.updateImageAndStepper()
            SVProgressHUD.dismiss()
        }
    }
    
    private func updateImageAndStepper() {
        let step = Int(stepSlider.value)
        stepSlider.isHidden = generator == nil
        hqButton.isHidden = generator == nil
        stepLabel.isHidden = generator == nil
        stepLabel.text = String(step + 1)
        imageView.image = generator?.draw(until: step)
    }
    
    // MARK: Actions
    @IBAction private func configChanged() {
        updateGenerators()
    }
    
    @IBAction private func colorsChanged() {
        updateGenerators()
    }
    
    @IBAction private func stepSliderChanged() {
        updateImageAndStepper()
    }
    
    @IBAction private func hqButtonTap() {
        SVProgressHUD.show()
        
        let config = RondConfig.all[self.segmentsConfigs.selectedSegmentIndex]
        let colors = ColorsConfig.all[self.segmentsColors.selectedSegmentIndex]
        let step = Int(stepSlider.value)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let gen = RondGenerator(
                renderSize: CGSize(width: 1000, height: 1000),
                rondConfig: config,
                renderConfig: RenderConfig.defaultRond,
                colorsConfig: colors
            )
            let image = gen.draw(until: step)
            self.imageView.image = image
            SVProgressHUD.dismiss()
        }
    }
}

