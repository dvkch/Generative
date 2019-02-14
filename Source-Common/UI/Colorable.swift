//
//  Colorable.swift
//  Generative
//
//  Created by Stanislas Chevallier on 14/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

protocol Colorable {
    func updateAppeareance(with colors: ColorsConfig)
}

extension ColorsConfig {
    func updateAppearance(of items: [Colorable]) {
        items.forEach { (element) in
            element.updateAppeareance(with: self)
        }
    }
}

extension UISegmentedControl : Colorable {
    func updateAppeareance(with colors: ColorsConfig) {
        tintColor = colors.linesColor
    }
}

extension UISlider : Colorable {
    func updateAppeareance(with colors: ColorsConfig) {
        minimumTrackTintColor = colors.linesColor
        maximumTrackTintColor = .gray
    }
}

extension UILabel : Colorable {
    func updateAppeareance(with colors: ColorsConfig) {
        textColor = colors.linesColor
    }
}

extension UIButton : Colorable {
    func updateAppeareance(with colors: ColorsConfig) {
        layer.cornerRadius = 5
        layer.masksToBounds = true
        setTitleColor(colors.backgroundColor, for: .normal)
        backgroundColor = colors.linesColor
    }
}
