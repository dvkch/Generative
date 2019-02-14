//
//  ColorsConfig.swift
//  Generative
//
//  Created by Stanislas Chevallier on 14/02/2019.
//  Copyright © 2019 Syan.me. All rights reserved.
//

import UIKit

enum ColorsConfig {
    case darkBlue
    case black
    case orange
    
    var linesColor: UIColor {
        switch self {
        case .darkBlue, .black: return UIColor.white
        case .orange:           return UIColor.orange
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .darkBlue: return UIColor(red: 41/255, green: 76/255, blue: 92/255, alpha: 1)
        case .black:    return UIColor.black
        case .orange:   return UIColor.white
        }
    }
}

extension ColorsConfig : Configurable {
    var description: String {
        switch self {
        case .darkBlue: return "darkBlue"
        case .black:    return "black"
        case .orange:   return "orange"
        }
    }
    
    static var all: [ColorsConfig] {
        return [.darkBlue, .black, .orange]
    }
}
