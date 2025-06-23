//
//  Borders.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/21/25.
//

import Foundation
import GameplayKit

class Borders: SKNode {
    // TODO: Clean this up
    var scale = Util.scale
    
    var topBorder,
        topLeftCorner,
        topRightCorner,
        leftBorder,
        rightBorder,
        bottomBorder,
        middleBorder,
        middleLeftCorner,
        middleRightCorner,
        topLeftBorder,
        topRightBorder,
        bottomLeftCorner,
        bottomRightCorner: SKSpriteNode!
    
    var filler: SKSpriteNode!
    
    init(size: CGSize) {
        super.init()
        
        let minX = -size.width/2
        let maxX = size.width/2
        let minY = -size.height/2
        let maxY = size.height/2
        
        topLeftCorner = makeNode(
            texture: Util.currentTheme.borders.cornerTopLeft,
            position: CGPoint(x: minX, y: maxY),
            zPosition: 2
        )
        self.addChild(topLeftCorner)

        topRightCorner = makeNode(
            texture: Util.currentTheme.borders.cornerTopRight,
            position: CGPoint(
                x: maxX - Util.currentTheme.borders.cornerTopRight.size().width * scale,
                y: maxY),
            zPosition: 2
        )
        self.addChild(topRightCorner)

        topBorder = makeNode(
            texture: Util.currentTheme.borders.borderTop,
            position: CGPoint(x: minX, y: maxY)
        )
        topBorder.xScale = size.width
        self.addChild(topBorder)
        
        middleBorder = makeNode(
            texture: Util.currentTheme.borders.borderMiddle,
            position: CGPoint(
                x: minX,
                y: (topBorder.frame.minY - scale * 33)),
            zPosition: 2
        )
        middleBorder.xScale = size.width
        self.addChild(middleBorder)
        
        bottomBorder = makeNode(
            texture: Util.currentTheme.borders.borderBottom,
            position: CGPoint(
                x: minX,
                y: minY + Util.currentTheme.borders.borderBottom.size().height * scale)
        )
        bottomBorder.xScale = size.width
        self.addChild(bottomBorder)
        
        middleLeftCorner = makeNode(
            texture: Util.currentTheme.borders.cornerMiddleLeft,
            position: CGPoint(x: minX, y: middleBorder.position.y),
            zPosition: 3
        )
        self.addChild(middleLeftCorner)

        middleRightCorner = makeNode(
            texture: Util.currentTheme.borders.cornerMiddleRight,
            position: CGPoint(
                x: maxX - Util.currentTheme.borders.cornerMiddleRight.size().width * scale,
                y: middleBorder.position.y),
            zPosition: 3
        )
        self.addChild(middleRightCorner)
        
        topLeftBorder = makeNode(
            texture: Util.currentTheme.borders.borderTopLeft,
            position: CGPoint(x: minX, y: maxY)
        )
        topLeftBorder.yScale = (size.height/2 - middleLeftCorner.position.y)
        self.addChild(topLeftBorder)

        topRightBorder = makeNode(
            texture: Util.currentTheme.borders.borderTopRight,
            position: CGPoint(
                x: maxX - Util.currentTheme.borders.borderTopRight.size().width * scale,
                y: maxY
            )
        )
        topRightBorder.yScale = (maxY - middleRightCorner.position.y)
        self.addChild(topRightBorder)

        leftBorder = makeNode(
            texture: Util.currentTheme.borders.borderLeft,
            position: CGPoint(x: minX, y: maxY - topLeftBorder.size.height)
        )
        leftBorder.yScale = (middleLeftCorner.position.y - minY)
        self.addChild(leftBorder)

        rightBorder = makeNode(
            texture: Util.currentTheme.borders.borderRight,
            position: CGPoint(
                x: maxX - Util.currentTheme.borders.borderRight.size().width * scale,
                y: maxY - topRightBorder.size.height
            )
        )
        rightBorder.yScale = (middleRightCorner.position.y - minY)
        self.addChild(rightBorder)
        
        bottomLeftCorner = makeNode(
            texture: Util.currentTheme.borders.cornerBottomLeft,
            position: CGPoint(x: minX, y: bottomBorder.position.y)
        )
        self.addChild(bottomLeftCorner)

        bottomRightCorner = makeNode(
            texture: Util.currentTheme.borders.cornerBottomRight,
            position: CGPoint(
                x: maxX - Util.currentTheme.borders.cornerBottomRight.size().width * scale,
                y: bottomBorder.position.y
            )
        )
        self.addChild(bottomRightCorner)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Factory method for creating nodes for the game border
    /// - Parameters:
    ///   - texture: The current theme's texture for this node
    ///   - position: A specified 2D position for this node
    ///   - zPosition: The node's optional Z position
    /// - Returns: A properly scaled SKSpriteNode with the given texture and position
    private func makeNode(texture: SKTexture, position: CGPoint, zPosition: CGFloat = 0) -> SKSpriteNode {
        let node = SKSpriteNode(texture: texture)
        node.anchorPoint = CGPoint(x: 0, y: 1)
        node.position = position
        node.setScale(scale)
        if zPosition != 0 {
            node.zPosition = zPosition
        }
        
        return node
    }
    
    func updateTextures() {
        topLeftCorner.texture = Util.currentTheme.borders.cornerTopLeft
        topRightCorner.texture = Util.currentTheme.borders.cornerTopRight
        topBorder.texture = Util.currentTheme.borders.borderTop
        middleBorder.texture = Util.currentTheme.borders.borderMiddle
        bottomBorder.texture = Util.currentTheme.borders.borderBottom
        middleLeftCorner.texture = Util.currentTheme.borders.cornerMiddleLeft
        middleRightCorner.texture = Util.currentTheme.borders.cornerMiddleRight
        topLeftBorder.texture = Util.currentTheme.borders.borderTopLeft
        topRightBorder.texture = Util.currentTheme.borders.borderTopRight
        leftBorder.texture = Util.currentTheme.borders.borderLeft
        rightBorder.texture = Util.currentTheme.borders.borderRight
        bottomLeftCorner.texture = Util.currentTheme.borders.cornerBottomLeft
        bottomRightCorner.texture = Util.currentTheme.borders.cornerBottomRight
//        filler.texture = Util.currentTheme.borders.filler
    }
    
}
