//
//  Util.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 5/30/22.
//

import Foundation
import SpriteKit

class Util {
    static let scale = CGFloat(2)
    static var difficulties = ["Beginner": [8, 8, 10], "Intermediate": [16, 16, 40], "Hard": [16, 30, 99]]
    
    static func convertLocation(name: String) -> Array<Int> {
        let coords = name.components(separatedBy: ",")
        let r = Int(String(coords[0]))!
        let c = Int(String(coords[1]))!
        return [r, c]
    }
    
    static func textureLookup(value: Value) -> SKTexture {
        switch value {
        case .Mine:
            return Resources.tiles.mine
        case .MineRed:
            return Resources.tiles.mineRed
        case .MineWrong:
            return Resources.tiles.mineWrong
        case .One:
            return Resources.tiles.one
        case .Two:
            return Resources.tiles.two
        case .Three:
            return Resources.tiles.three
        case .Four:
            return Resources.tiles.four
        case .Five:
            return Resources.tiles.five
        case .Six:
            return Resources.tiles.six
        case .Seven:
            return Resources.tiles.seven
        case .Eight:
            return Resources.tiles.eight
        default:
            return Resources.tiles.empty
        }
    }
}
