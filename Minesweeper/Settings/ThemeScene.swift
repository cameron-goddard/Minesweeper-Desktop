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
        
        let positions = [CGPoint(x: 0, y: 0), CGPoint(x: 32, y: 0), CGPoint(x: 32, y: 32), CGPoint(x: 0, y: 32)]
        
        for i in 0..<4 {
            let cell = SKSpriteNode(texture: theme.tiles.covered)
            cell.setScale(2)
            cell.anchorPoint = CGPoint(x: 0, y: 0)
            cell.position = positions[i]
            self.addChild(cell)
        }
        
        let mineCell = SKSpriteNode(texture: theme.tiles.mine)
        mineCell.setScale(2)
        mineCell.anchorPoint = CGPoint(x: 0, y: 0)
        mineCell.position = CGPoint(x: 96, y: 32)
        self.addChild(mineCell)
        
        let mineRedCell = SKSpriteNode(texture: theme.tiles.mineRed)
        mineRedCell.setScale(2)
        mineRedCell.anchorPoint = CGPoint(x: 0, y: 0)
        mineRedCell.position = CGPoint(x: 96, y: 64)
        self.addChild(mineRedCell)
        
        let flagCell = SKSpriteNode(texture: theme.tiles.flagged)
        flagCell.setScale(2)
        flagCell.anchorPoint = CGPoint(x: 0, y: 0)
        flagCell.position = CGPoint(x: 96, y: 0)
        self.addChild(flagCell)
        
        let fourCell = SKSpriteNode(texture: theme.tiles.four)
        fourCell.setScale(2)
        fourCell.anchorPoint = CGPoint(x: 0, y: 0)
        fourCell.position = CGPoint(x: 0, y: 64)
        self.addChild(fourCell)
        
        let twoCell = SKSpriteNode(texture: theme.tiles.two)
        twoCell.setScale(2)
        twoCell.anchorPoint = CGPoint(x: 0, y: 0)
        twoCell.position = CGPoint(x: 32, y: 64)
        self.addChild(twoCell)
        
        let questionCell = SKSpriteNode(texture: theme.tiles.question)
        questionCell.setScale(2)
        questionCell.anchorPoint = CGPoint(x: 0, y: 0)
        questionCell.position = CGPoint(x: 64, y: 0)
        self.addChild(questionCell)
        
        let emptyCell = SKSpriteNode(texture: theme.tiles.empty)
        emptyCell.setScale(2)
        emptyCell.anchorPoint = CGPoint(x: 0, y: 0)
        emptyCell.position = CGPoint(x: 64, y: 32)
        self.addChild(emptyCell)
        
        let emptyCell2 = SKSpriteNode(texture: theme.tiles.empty)
        emptyCell2.setScale(2)
        emptyCell2.anchorPoint = CGPoint(x: 0, y: 0)
        emptyCell2.position = CGPoint(x: 64, y: 64)
        self.addChild(emptyCell2)
        
        for i in 0..<7 {
            let cell = SKSpriteNode(texture: theme.tiles.covered)
            cell.setScale(2)
            cell.anchorPoint = CGPoint(x: 0, y: 0)
            cell.position = CGPoint(x: i*32, y: 96)
            self.addChild(cell)
        }
        
        
    }
    
}
