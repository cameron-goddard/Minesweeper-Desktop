//
//  Theme.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/27/22.
//

import Foundation
import SpriteKit

@objc class Theme: NSObject {

    let name: String
    let fileName: String
    let desc: String

    let mainButton: MainButton
    let numbers: Numbers
    let tiles: Tiles
    let borders: Borders

    var isDefault: Bool
    var isCurrent: Bool = false
    var isFavorite: Bool

    init(
        name: String, fileName: String = "", desc: String = "User-generated theme",
        isDefault: Bool = false, isFavorite: Bool = false, spriteSheetTexture: SKTexture
    ) {

        mainButton = MainButton(tileSheet: SpriteSheet(atlas: spriteSheetTexture))
        numbers = Numbers(tileSheet: SpriteSheet(atlas: spriteSheetTexture))
        tiles = Tiles(tileSheet: SpriteSheet(atlas: spriteSheetTexture))
        borders = Borders(tileSheet: SpriteSheet(atlas: spriteSheetTexture))

        self.name = name
        self.fileName = fileName
        self.desc = desc
        self.isDefault = isDefault
        self.isFavorite = isFavorite
    }

    struct Tiles {
        let empty: SKTexture
        let one: SKTexture
        let two: SKTexture
        let three: SKTexture
        let four: SKTexture
        let five: SKTexture
        let six: SKTexture
        let seven: SKTexture
        let eight: SKTexture

        let covered: SKTexture
        let pressed: SKTexture
        let flagged: SKTexture
        let question: SKTexture
        let questionPressed: SKTexture
        let mine: SKTexture
        let mineRed: SKTexture
        let mineWrong: SKTexture

        init(tileSheet: SpriteSheet) {
            empty = tileSheet.textureAt(x: 0, y: 106, w: 16, h: 16)
            one = tileSheet.textureAt(x: 16, y: 106, w: 16, h: 16)
            two = tileSheet.textureAt(x: 32, y: 106, w: 16, h: 16)
            three = tileSheet.textureAt(x: 48, y: 106, w: 16, h: 16)
            four = tileSheet.textureAt(x: 64, y: 106, w: 16, h: 16)
            five = tileSheet.textureAt(x: 80, y: 106, w: 16, h: 16)
            six = tileSheet.textureAt(x: 96, y: 106, w: 16, h: 16)
            seven = tileSheet.textureAt(x: 112, y: 106, w: 16, h: 16)
            eight = tileSheet.textureAt(x: 128, y: 106, w: 16, h: 16)

            covered = tileSheet.textureAt(x: 0, y: 90, w: 16, h: 16)
            pressed = tileSheet.textureAt(x: 16, y: 90, w: 16, h: 16)
            flagged = tileSheet.textureAt(x: 48, y: 90, w: 16, h: 16)
            question = tileSheet.textureAt(x: 96, y: 90, w: 16, h: 16)
            questionPressed = tileSheet.textureAt(x: 112, y: 90, w: 16, h: 16)
            mine = tileSheet.textureAt(x: 32, y: 90, w: 16, h: 16)
            mineRed = tileSheet.textureAt(x: 80, y: 90, w: 16, h: 16)
            mineWrong = tileSheet.textureAt(x: 64, y: 90, w: 16, h: 16)
        }
    }

    struct MainButton {
        let happy: SKTexture
        let happyPressed: SKTexture
        let cautious: SKTexture
        let cool: SKTexture
        let dead: SKTexture

        init(tileSheet: SpriteSheet) {
            happy = tileSheet.textureAt(x: 0, y: 41, w: 26, h: 26)
            cautious = tileSheet.textureAt(x: 27, y: 41, w: 26, h: 26)
            dead = tileSheet.textureAt(x: 54, y: 41, w: 26, h: 26)
            cool = tileSheet.textureAt(x: 81, y: 41, w: 26, h: 26)
            happyPressed = tileSheet.textureAt(x: 108, y: 41, w: 26, h: 26)
        }
    }

    struct Numbers {
        var digits = [SKTexture]()

        init(tileSheet: SpriteSheet) {
            for i in 0..<12 {
                digits.append(tileSheet.textureAt(x: i + (i * 11), y: 68, w: 11, h: 21))
            }
        }
    }

    struct Borders {
        let cornerTopLeft,
            cornerTopRight,
            cornerMiddleLeft,
            cornerMiddleRight,
            cornerBottomLeft,
            cornerBottomRight: SKTexture

        let borderTopLeft,
            borderTopRight,
            borderLeft,
            borderRight: SKTexture

        let borderTop,
            borderMiddle,
            borderBottom: SKTexture

        let borderNumbers: SKTexture

        let filler: SKTexture

        init(tileSheet: SpriteSheet) {
            cornerTopLeft = tileSheet.textureAt(x: 0, y: 29, w: 12, h: 11)
            cornerTopRight = tileSheet.textureAt(x: 15, y: 29, w: 12, h: 11)
            cornerMiddleLeft = tileSheet.textureAt(x: 0, y: 15, w: 11, h: 11)
            cornerMiddleRight = tileSheet.textureAt(x: 16, y: 15, w: 11, h: 11)
            cornerBottomLeft = tileSheet.textureAt(x: 0, y: 0, w: 12, h: 12)
            cornerBottomRight = tileSheet.textureAt(x: 15, y: 0, w: 12, h: 12)

            borderTopLeft = tileSheet.textureAt(x: 0, y: 27, w: 12, h: 1)
            borderTopRight = tileSheet.textureAt(x: 15, y: 27, w: 12, h: 1)
            borderLeft = tileSheet.textureAt(x: 15, y: 13, w: 12, h: 1)
            borderRight = tileSheet.textureAt(x: 15, y: 13, w: 12, h: 1)

            borderTop = tileSheet.textureAt(x: 13, y: 29, w: 1, h: 11)
            borderMiddle = tileSheet.textureAt(x: 13, y: 15, w: 1, h: 11)
            borderBottom = tileSheet.textureAt(x: 13, y: 0, w: 1, h: 12)

            borderNumbers = tileSheet.textureAt(x: 28, y: 15, w: 41, h: 25)

            filler = tileSheet.textureAt(x: 70, y: 39, w: 1, h: 1)
        }
    }
}
