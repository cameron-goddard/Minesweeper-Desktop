//
//  ThemeScene.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/20/22.
//

import Cocoa
import GameplayKit
import SpriteKit

class ThemeScene: SKScene {
    
    let theme: Theme
    
    init(theme: Theme) {
        self.theme = theme
        super.init(size: CGSize(width: 224, height: 128))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = NSColor(red: 0, green: 0, blue: 61, alpha: 1)
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        // row 3
        for i in 0..<6 {
            addCell(texture: theme.tiles.covered, r: 3, c: i)
        }
        addCell(texture: theme.tiles.mineRed, r: 3, c: 6)
        
        // row 2
        addCell(texture: theme.tiles.covered, r: 2, c: 0)
        addCell(texture: theme.tiles.one, r: 2, c: 1)
        addCell(texture: theme.tiles.two, r: 2, c: 2)
        addCell(texture: theme.tiles.three, r: 2, c: 3)
        addCell(texture: theme.tiles.four, r: 2, c: 4)
        addCell(texture: theme.tiles.empty, r: 2, c: 5)
        addCell(texture: theme.tiles.mineWrong, r: 2, c: 6)
        
        // row 1
        addCell(texture: theme.tiles.covered, r: 1, c: 0)
        addCell(texture: theme.tiles.five, r: 1, c: 1)
        addCell(texture: theme.tiles.six, r: 1, c: 2)
        addCell(texture: theme.tiles.seven, r: 1, c: 3)
        addCell(texture: theme.tiles.eight, r: 1, c: 4)
        addCell(texture: theme.tiles.empty, r: 1, c: 5)
        addCell(texture: theme.tiles.mine, r: 1, c: 6)
        
        // row 0
        for i in 0..<5 {
            addCell(texture: theme.tiles.covered, r: 0, c: i)
        }
        addCell(texture: theme.tiles.question, r: 0, c: 5)
        addCell(texture: theme.tiles.flagged, r: 0, c: 6)
    }
    
    func addCell(texture: SKTexture, r: Int, c: Int) {
        let cell = SKSpriteNode(texture: texture)
        cell.setScale(2)
        cell.anchorPoint = CGPoint(x: 0, y: 0)
        cell.position = CGPoint(x: c*32, y: r*32)
        self.addChild(cell)
    }
}
