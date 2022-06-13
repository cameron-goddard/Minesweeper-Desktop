//
//  Tile.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import Foundation
import SpriteKit

enum State {
    case Covered
    case Uncovered
    case Flagged
    case Question
}

enum Value {
    case Mine
    case MineRed
    case MineWrong
    case Empty
    case One
    case Two
    case Three
    case Four
    case Five
    case Six
    case Seven
    case Eight
}

class Tile {
    
    let node = SKSpriteNode()
    
    var r: Int
    var c: Int
    var state: State
    var value: Value
    
    init(r: Int, c: Int, state: State, val: Value = .Empty) {
        self.r = r
        self.c = c
        self.state = state
        self.value = val
        self.node.texture = Resources.tiles.covered
        self.node.anchorPoint = CGPoint(x: 0, y: 1)
        self.node.name = String(r) + "," + String(c)
    }
    
    init() {
        self.r = 0
        self.c = 0
        self.state = .Question
        self.value = .Empty
    }
    
    func setState(state: State) {
        self.state = state
        
        switch state {
        case .Uncovered:
            self.node.texture = Util.textureLookup(value: self.value)
        case .Covered:
            self.node.texture = Resources.tiles.covered
        case .Flagged:
            self.node.texture = Resources.tiles.flagged
        case .Question:
            self.node.texture = Resources.tiles.question
        }
    }
    
    func setValue(val: Value) {
        self.value = val
    }
    
    func isNumber() -> Bool {
        return self.value == .One || self.value == .Two || self.value == .Three || self.value == .Four || self.value == .Five || self.value == .Six || self.value == .Seven || self.value == .Eight
    }
}
