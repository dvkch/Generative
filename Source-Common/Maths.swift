//
//  Maths.swift
//  Rond
//
//  Created by Stanislas Chevallier on 09/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

struct Maths {
    static func random(max: CGFloat, steps: UInt32, center: Bool) -> CGFloat {
        let value = CGFloat(arc4random() % steps) / CGFloat(steps) * max
        return value - (center ? max / 2 : 0)
    }
}


extension CGSize {
    var min: CGFloat {
        return Swift.min(width, height)
    }
}
