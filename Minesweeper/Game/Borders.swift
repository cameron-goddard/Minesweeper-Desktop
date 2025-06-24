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
            texture: ThemeManager.shared.currentTheme.borders.filler,
            position: CGPoint(x: minX, y: maxY),
            xScale: size.width,
            yScale: 66 * scale
        )
        
        topLeftCorner = makeNode(
            texture: ThemeManager.shared.currentTheme.borders.cornerTopLeft,
            position: CGPoint(x: minX, y: maxY),
            zPosition: 2
        )

        topRightCorner = makeNode(
            texture: ThemeManager.shared.currentTheme.borders.cornerTopRight,
            position: CGPoint(
                x: maxX - ThemeManager.shared.currentTheme.borders.cornerTopRight.size().width * scale,
                y: maxY
            ),
            zPosition: 2
        )

        topBorder = makeNode(
            texture: ThemeManager.shared.currentTheme.borders.borderTop,
            position: CGPoint(x: minX, y: maxY),
            xScale: size.width
        )
        
        middleBorder = makeNode(
            texture: ThemeManager.shared.currentTheme.borders.borderMiddle,
            position: CGPoint(
                x: minX,
                y: topBorder.frame.minY - scale * 33
            ),
            xScale: size.width,
            zPosition: 2
        )
        
        bottomBorder = makeNode(
            texture: ThemeManager.shared.currentTheme.borders.borderBottom,
            position: CGPoint(
                x: minX,
                y: minY + ThemeManager.shared.currentTheme.borders.borderBottom.size().height * scale
            ),
            xScale: size.width
        )
        
        middleLeftCorner = makeNode(
            texture: ThemeManager.shared.currentTheme.borders.cornerMiddleLeft,
            position: CGPoint(x: minX, y: middleBorder.position.y),
            zPosition: 3
        )

        middleRightCorner = makeNode(
            texture: ThemeManager.shared.currentTheme.borders.cornerMiddleRight,
            position: CGPoint(
                x: maxX - ThemeManager.shared.currentTheme.borders.cornerMiddleRight.size().width * scale,
                y: middleBorder.position.y
            ),
            zPosition: 3
        )
        
        topLeftBorder = makeNode(
            texture: ThemeManager.shared.currentTheme.borders.borderTopLeft,
            position: CGPoint(x: minX, y: maxY),
            yScale: maxY - middleLeftCorner.position.y
        )

        topRightBorder = makeNode(
            texture: ThemeManager.shared.currentTheme.borders.borderTopRight,
            position: CGPoint(
                x: maxX - ThemeManager.shared.currentTheme.borders.borderTopRight.size().width * scale,
                y: maxY
            ),
            yScale: maxY - middleRightCorner.position.y
        )

        leftBorder = makeNode(
            texture: ThemeManager.shared.currentTheme.borders.borderLeft,
            position: CGPoint(x: minX, y: maxY - topLeftBorder.size.height),
            yScale: middleLeftCorner.position.y - minY
        )

        rightBorder = makeNode(
            texture: ThemeManager.shared.currentTheme.borders.borderRight,
            position: CGPoint(
                x: maxX - ThemeManager.shared.currentTheme.borders.borderRight.size().width * scale,
                y: maxY - topRightBorder.size.height
            ),
            yScale: middleRightCorner.position.y - minY
        )
        
        bottomLeftCorner = makeNode(
            texture: ThemeManager.shared.currentTheme.borders.cornerBottomLeft,
            position: CGPoint(x: minX, y: bottomBorder.position.y)
        )

        bottomRightCorner = makeNode(
            texture: ThemeManager.shared.currentTheme.borders.cornerBottomRight,
            position: CGPoint(
                x: maxX - ThemeManager.shared.currentTheme.borders.cornerBottomRight.size().width * scale,
                y: bottomBorder.position.y
            )
        )
        
        filler = makeNode(
            texture: ThemeManager.shared.currentTheme.borders.filler,
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
        background.texture = ThemeManager.shared.currentTheme.borders.filler
        topLeftCorner.texture = ThemeManager.shared.currentTheme.borders.cornerTopLeft
        topRightCorner.texture = ThemeManager.shared.currentTheme.borders.cornerTopRight
        topBorder.texture = ThemeManager.shared.currentTheme.borders.borderTop
        middleBorder.texture = ThemeManager.shared.currentTheme.borders.borderMiddle
        bottomBorder.texture = ThemeManager.shared.currentTheme.borders.borderBottom
        middleLeftCorner.texture = ThemeManager.shared.currentTheme.borders.cornerMiddleLeft
        middleRightCorner.texture = ThemeManager.shared.currentTheme.borders.cornerMiddleRight
        topLeftBorder.texture = ThemeManager.shared.currentTheme.borders.borderTopLeft
        topRightBorder.texture = ThemeManager.shared.currentTheme.borders.borderTopRight
        leftBorder.texture = ThemeManager.shared.currentTheme.borders.borderLeft
        rightBorder.texture = ThemeManager.shared.currentTheme.borders.borderRight
        bottomLeftCorner.texture = ThemeManager.shared.currentTheme.borders.cornerBottomLeft
        bottomRightCorner.texture = ThemeManager.shared.currentTheme.borders.cornerBottomRight
        filler.texture = ThemeManager.shared.currentTheme.borders.filler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
