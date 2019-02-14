//
//  Configurable.swift
//  Generative
//
//  Created by Stanislas Chevallier on 14/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

protocol Configurable {
    var description: String { get }
    static var all: [Self] { get }
}

extension UISegmentedControl {
    func updateWithConfigurable<T: Configurable>(configurable: T.Type) {
        removeAllSegments()
        T.all.forEach { (config) in
            insertSegment(withTitle: config.description, at: numberOfSegments, animated: false)
        }
        selectedSegmentIndex = 0
    }
}
