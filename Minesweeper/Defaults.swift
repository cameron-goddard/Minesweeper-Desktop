//
//  Defaults.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/24/25.
//

import Defaults
import Foundation

extension Defaults.Keys {

    enum Game {
        static let difficulty = Key<String>("difficulty", default: "Beginner")
        static let customDifficulty = Key<[Int]>("customDifficulty", default: [-1, -1, -1])
    }

    enum General {
        static let appearance = Key<String>("appearance", default: "Light")
        static let toolbarDifficulty = Key<Bool>("toolbarDifficulty", default: false)
        static let scale = Key<CGFloat>("scale", default: 1.5)
        static let questions = Key<Bool>("questions", default: false)
        static let safeFirstClick = Key<Bool>("safeFirstClick", default: true)
    }

    enum Themes {
        static let theme = Key<String>("theme", default: "Classic")
        static let favorites = Key<[String]>(
            "favorites",
            default: [
                "Classic",
                "Classic Dark",
                "Classic 95",
            ])
    }

    enum Keys {

    }
}
