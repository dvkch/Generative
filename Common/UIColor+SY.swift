//
//  UIColor+SY.swift
//  Rond
//
//  Created by Stanislas Chevallier on 09/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

extension UIColor {
    func withBrightness(_ brightness: CGFloat) -> UIColor {
        var h = CGFloat(0)
        var s = CGFloat(0)
        var a = CGFloat(0)
        self.getHue(&h, saturation: &s, brightness: nil, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: brightness, alpha: a)
    }
}
