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
    
    var background: SKSpriteNode!
    var filler: SKSpriteNode!
    
    init(size: CGSize) {
        super.init()
        
        let minX = -size.width / 2
        let maxX = size.width / 2
        let minY = -size.height / 2
        let maxY = size.height / 2
        
        background = makeNode(
            texture: Util.currentTheme.borders.filler,
            position: CGPoint(x: minX, y: maxY),
            xScale: size.width,
            yScale: 66 * scale
        )
        
        topLeftCorner = makeNode(
            texture: Util.currentTheme.borders.cornerTopLeft,
            position: CGPoint(x: minX, y: maxY),
            zPosition: 2
        )

        topRightCorner = makeNode(
            texture: Util.currentTheme.borders.cornerTopRight,
            position: CGPoint(
                x: maxX - Util.currentTheme.borders.cornerTopRight.size().width * scale,
                y: maxY
            ),
            zPosition: 2
        )

        topBorder = makeNode(
            texture: Util.currentTheme.borders.borderTop,
            position: CGPoint(x: minX, y: maxY),
            xScale: size.width
        )
        
        middleBorder = makeNode(
            texture: Util.currentTheme.borders.borderMiddle,
            position: CGPoint(
                x: minX,
                y: topBorder.frame.minY - scale * 33
            ),
            xScale: size.width,
            zPosition: 2
        )
        
        bottomBorder = makeNode(
            texture: Util.currentTheme.borders.borderBottom,
            position: CGPoint(
                x: minX,
                y: minY + Util.currentTheme.borders.borderBottom.size().height * scale
            ),
            xScale: size.width
        )
        
        middleLeftCorner = makeNode(
            texture: Util.currentTheme.borders.cornerMiddleLeft,
            position: CGPoint(x: minX, y: middleBorder.position.y),
            zPosition: 3
        )

        middleRightCorner = makeNode(
            texture: Util.currentTheme.borders.cornerMiddleRight,
            position: CGPoint(
                x: maxX - Util.currentTheme.borders.cornerMiddleRight.size().width * scale,
                y: middleBorder.position.y
            ),
            zPosition: 3
        )
        
        topLeftBorder = makeNode(
            texture: Util.currentTheme.borders.borderTopLeft,
            position: CGPoint(x: minX, y: maxY),
            yScale: maxY - middleLeftCorner.position.y
        )

        topRightBorder = makeNode(
            texture: Util.currentTheme.borders.borderTopRight,
            position: CGPoint(
                x: maxX - Util.currentTheme.borders.borderTopRight.size().width * scale,
                y: maxY
            ),
            yScale: maxY - middleRightCorner.position.y
        )

        leftBorder = makeNode(
            texture: Util.currentTheme.borders.borderLeft,
            position: CGPoint(x: minX, y: maxY - topLeftBorder.size.height),
            yScale: middleLeftCorner.position.y - minY
        )

        rightBorder = makeNode(
            texture: Util.currentTheme.borders.borderRight,
            position: CGPoint(
                x: maxX - Util.currentTheme.borders.borderRight.size().width * scale,
                y: maxY - topRightBorder.size.height
            ),
            yScale: middleRightCorner.position.y - minY
        )
        
        bottomLeftCorner = makeNode(
            texture: Util.currentTheme.borders.cornerBottomLeft,
            position: CGPoint(x: minX, y: bottomBorder.position.y)
        )

        bottomRightCorner = makeNode(
            texture: Util.currentTheme.borders.cornerBottomRight,
            position: CGPoint(
                x: maxX - Util.currentTheme.borders.cornerBottomRight.size().width * scale,
                y: bottomBorder.position.y
            )
        )
        
        filler = makeNode(
            texture: Util.currentTheme.borders.filler,
            position: CGPoint(
                x: middleRightCorner.position.x - scale,
                y: middleBorder.position.y-middleBorder.size.height + scale
            ),
            zPosition: 4
        )
        
        self.addChild(background)
        self.addChild(topLeftCorner)
        self.addChild(topRightCorner)
        self.addChild(topBorder)
        self.addChild(middleBorder)
        self.addChild(bottomBorder)
        self.addChild(middleLeftCorner)
        self.addChild(middleRightCorner)
        self.addChild(topLeftBorder)
        self.addChild(topRightBorder)
        self.addChild(leftBorder)
        self.addChild(rightBorder)
        self.addChild(bottomLeftCorner)
        self.addChild(bottomRightCorner)
        self.addChild(filler)
    }
    
    /// Factory method for creating nodes for the game border
    /// - Parameters:
    ///   - texture: The current theme's texture for this node
    ///   - position: A specified 2D position for this node
    ///   - xScale: The node's optional x scaling
    ///   - yScale: The node's optional y scaling
    ///   - zPosition: The node's optional Z position
    /// - Returns: A properly scaled SKSpriteNode with the given texture and position
    private func makeNode(texture: SKTexture, position: CGPoint, xScale: CGFloat = 1, yScale: CGFloat = 1, zPosition: CGFloat = 0) -> SKSpriteNode {
        
        let node = SKSpriteNode(texture: texture)
        node.anchorPoint = CGPoint(x: 0, y: 1)
        node.position = position
        node.setScale(scale)
        if xScale != 1 {
            node.xScale = xScale
        }
        if yScale != 1 {
            node.yScale = yScale
        }
        if zPosition != 0 {
            node.zPosition = zPosition
        }
        
        return node
    }
    
    /// Force update border textures. Called when a theme is changed
    func updateTextures() {
        background.texture = Util.currentTheme.borders.filler
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
        filler.texture = Util.currentTheme.borders.filler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
