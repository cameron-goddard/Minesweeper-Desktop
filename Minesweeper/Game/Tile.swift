//
//  Tile.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import Foundation
import SpriteKit

class Tile {

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

    let node: SKSpriteNode

    var r: Int
    var c: Int
    var state: State
    var value: Value

    init(r: Int, c: Int, state: State, val: Value = .Empty) {
        self.node = SKSpriteNode()
        self.r = r
        self.c = c
        self.state = state
        self.value = val
        self.node.texture = ThemeManager.shared.current.tiles.covered
        self.node.anchorPoint = CGPoint(x: 0, y: 1)
        self.node.name = String(r) + "," + String(c)
    }

    init() {
        self.node = SKSpriteNode()
        self.r = 0
        self.c = 0
        self.state = .Question
        self.value = .Empty
    }

    func setState(state: State, theme: Theme = ThemeManager.shared.current) {
        self.state = state

        switch state {
        case .Uncovered:
            self.node.texture = textureLookup(value: self.value, theme: theme)
        case .Covered:
            self.node.texture = theme.tiles.covered
        case .Flagged:
            self.node.texture = theme.tiles.flagged
        case .Question:
            self.node.texture = theme.tiles.question
        }
    }

    func setValue(val: Value) {
        self.value = val
    }

    func isNumber() -> Bool {
        return
            !(self.value == .Empty || self.value == .Mine || self.value == .MineRed
            || self.value == .MineWrong)
    }

    func pressed() {
        if self.state == .Question {
            self.node.texture = ThemeManager.shared.current.tiles.questionPressed
        } else {
            self.node.texture = ThemeManager.shared.current.tiles.pressed
        }
    }

    func raised() {
        self.setState(state: self.state)
    }

    func textureLookup(value: Value, theme: Theme) -> SKTexture {
        switch value {
        case .Mine:
            return theme.tiles.mine
        case .MineRed:
            return theme.tiles.mineRed
        case .MineWrong:
            return theme.tiles.mineWrong
        case .One:
            return theme.tiles.one
        case .Two:
            return theme.tiles.two
        case .Three:
            return theme.tiles.three
        case .Four:
            return theme.tiles.four
        case .Five:
            return theme.tiles.five
        case .Six:
            return theme.tiles.six
        case .Seven:
            return theme.tiles.seven
        case .Eight:
            return theme.tiles.eight
        default:
            return theme.tiles.empty
        }
    }
}

extension Tile: Equatable {
    static func == (lhs: Tile, rhs: Tile) -> Bool {
        return lhs.r == rhs.r && lhs.c == rhs.c
    }
}

extension Tile: CustomStringConvertible {
    var description: String {
        return "[\(r), \(c)]"
    }
}
