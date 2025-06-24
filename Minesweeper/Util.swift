//
//  Util.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 5/30/22.
//

import Foundation
import SpriteKit
import Defaults

class Util {
    static let scale = CGFloat(1.5)
    
    static var difficulties = [
        "Beginner": [8, 8, 10],
        "Intermediate": [16, 16, 40],
        "Hard": [16, 30, 99],
        "Custom": [8, 8, 10]
    ]
}

extension Defaults.Keys {
    static let favorites = Key<Array<String>>("favorites", default: ["Classic", "Classic Dark", "Classic 95"])
}
