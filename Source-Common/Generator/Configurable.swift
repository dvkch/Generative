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

