//
//  Resources.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import Foundation
import SpriteKit

struct Resources {

    static var tiles: Tiles!
    static var mainButton: MainButton!
    static var numbers: Numbers!
    static var flagNumbers: Numbers!

    private init() { }

    static func initialize() {
        let spriteSheetTexture = SKTexture(imageNamed: "default_spritesheet")
        mainButton = MainButton(tileSheet: SpriteSheet(atlas: spriteSheetTexture, row: 0, columns: 5))
        flagNumbers = Numbers(tileSheet: SpriteSheet(atlas: spriteSheetTexture, row: 1, columns: 12))
        numbers = Numbers(tileSheet: SpriteSheet(atlas: spriteSheetTexture, row: 2, columns: 12))
        tiles = Tiles(tileSheet: SpriteSheet(atlas: spriteSheetTexture, row: 3, columns: 15))
    }

    struct Tiles {
        let empty: SKTexture
        let covered: SKTexture
        let one: SKTexture
        let two: SKTexture
        let three: SKTexture
        let four: SKTexture
        let five: SKTexture
        let six: SKTexture
        let seven: SKTexture
        let eight: SKTexture

        let flagged: SKTexture
        let question: SKTexture

        let mine: SKTexture
        let mineRed: SKTexture
        let mineWrong: SKTexture

        init(tileSheet: SpriteSheet) {
            covered = tileSheet.textureFor(col: 0)
            flagged = tileSheet.textureFor(col: 1)
            question = tileSheet.textureFor(col: 2)
            empty = tileSheet.textureFor(col: 3)
            one = tileSheet.textureFor(col: 4)
            two = tileSheet.textureFor(col: 5)
            three = tileSheet.textureFor(col: 6)
            four = tileSheet.textureFor(col: 7)
            five = tileSheet.textureFor(col: 8)
            six = tileSheet.textureFor(col: 9)
            seven = tileSheet.textureFor(col: 10)
            eight = tileSheet.textureFor(col: 11)
            
            mine = tileSheet.textureFor(col: 12)
            mineRed = tileSheet.textureFor(col: 13)
            mineWrong = tileSheet.textureFor(col: 14)
        }
    }
    
    struct MainButton {
        let happy: SKTexture
        let happyPressed: SKTexture
        let cautious: SKTexture
        let cool: SKTexture
        let dead: SKTexture
        
        init(tileSheet: SpriteSheet) {
            happy = tileSheet.textureFor(col: 0)
            happyPressed = tileSheet.textureFor(col: 1)
            cautious = tileSheet.textureFor(col: 2)
            cool = tileSheet.textureFor(col: 3)
            dead = tileSheet.textureFor(col: 4)
        }
    }
    
    struct Numbers {
        var digits = [SKTexture]()
        
        init(tileSheet: SpriteSheet) {
            for i in 0..<12 {
                digits.append(tileSheet.textureFor(col: i))
            }
        }
    }
}
