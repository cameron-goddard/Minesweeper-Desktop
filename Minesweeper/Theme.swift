//
//  Theme.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/27/22.
//

import Foundation
import SpriteKit

@objc class Theme: NSObject {
    
    let spriteSheetTexture: SKTexture
    let name: String
    let desc: String
    
    let mainButton: MainButton
    let flagNumbers: Numbers
    let numbers: Numbers
    let tiles: Tiles
    let borders: Borders
    let backgroundColor: NSColor
    
    var isDefault = true
    let style : String
    let mode : String
    var isCurrent = false
    
    init(name: String, desc: String = "User-generated theme", style: String = "Classic", mode: String = "Light", spriteSheetTexture: SKTexture, backgroundColor: NSColor) {
        self.spriteSheetTexture = spriteSheetTexture
        
        mainButton = MainButton(tileSheet: SpriteSheet(atlas: spriteSheetTexture, row: 0, columns: 5))
        flagNumbers = Numbers(tileSheet: SpriteSheet(atlas: spriteSheetTexture, row: 1, columns: 12))
        numbers = Numbers(tileSheet: SpriteSheet(atlas: spriteSheetTexture, row: 2, columns: 12))
        tiles = Tiles(tileSheet: SpriteSheet(atlas: spriteSheetTexture, row: 3, columns: 15))
        borders = Borders(tileSheet: SpriteSheet(atlas: spriteSheetTexture, row: 0, columns: 4))
        self.name = name
        self.desc = desc
        self.style = style
        self.mode = mode
        self.backgroundColor = backgroundColor
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
            mine.filteringMode = .nearest
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
    
    struct Borders {
        let cornerTopLeft: SKTexture
        let cornerTopRight: SKTexture
        let cornerMiddleLeft: SKTexture
        let cornerMiddleRight: SKTexture
        let cornerBottomLeft: SKTexture
        let cornerBottomRight: SKTexture
        
        let borderTopLeft: SKTexture
        let borderTopRight: SKTexture
        let borderLeft: SKTexture
        let borderRight: SKTexture
        
        let borderTop: SKTexture
        let borderMiddle: SKTexture
        let borderBottom: SKTexture
        
        let numberBorderLeft, numberBorderRight, numberBorderBottom, numberBorderTop: SKTexture
        
        init(tileSheet: SpriteSheet) {
            cornerTopLeft = tileSheet.textureForBorder(row: 0, col: 0)
            cornerTopRight = tileSheet.textureForBorder(row: 0, col: 1)
            cornerMiddleLeft = tileSheet.textureForBorder(row: 0, col: 2)
            cornerMiddleRight = tileSheet.textureForBorder(row: 0, col: 3)
            cornerBottomLeft = tileSheet.textureForBorder(row: 1, col: 0)
            cornerBottomRight = tileSheet.textureForBorder(row: 1, col: 1)
            
            borderTopLeft = tileSheet.textureForBorder(row: 2, col: 0)
            borderTopRight = tileSheet.textureForBorder(row: 2, col: 1)
            borderLeft = tileSheet.textureForBorder(row: 3, col: 0)
            borderRight = tileSheet.textureForBorder(row: 3, col: 0)
            
            borderTop = tileSheet.textureForBorder(row: 4, col: 0)
            borderMiddle = tileSheet.textureForBorder(row: 4, col: 1)
            borderBottom = tileSheet.textureForBorder(row: 5, col: 0)
            
            numberBorderLeft = tileSheet.textureForBorder(row: 6, col: 0)
            numberBorderRight = tileSheet.textureForBorder(row: 6, col: 1)
            numberBorderBottom = tileSheet.textureForBorder(row: 7, col: 0)
            numberBorderTop = tileSheet.textureForBorder(row: 7, col: 1)
        }
    }
}
