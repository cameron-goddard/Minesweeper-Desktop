//
//  Borders.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/21/25.
//

import Foundation
import GameplayKit
import Defaults

class Borders: SKNode {
    
    var sceneSize: CGSize
    var scale: CGFloat
    
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
    
    init(sceneSize: CGSize, scale: CGFloat) {
        self.sceneSize = sceneSize
        self.scale = scale
        super.init()
        
        addNodes()
    }
    
    private func addNodes() {
        let minX = -sceneSize.width / 2
        let maxX = sceneSize.width / 2
        let minY = -sceneSize.height / 2
        let maxY = sceneSize.height / 2
        
        background = makeNode(
            texture: ThemeManager.shared.current.borders.filler,
            position: CGPoint(x: minX, y: maxY),
            xScale: sceneSize.width,
            yScale: 66 * scale
        )
        
        topLeftCorner = makeNode(
            texture: ThemeManager.shared.current.borders.cornerTopLeft,
            position: CGPoint(x: minX, y: maxY),
            zPosition: 2
        )

        topRightCorner = makeNode(
            texture: ThemeManager.shared.current.borders.cornerTopRight,
            position: CGPoint(
                x: maxX - ThemeManager.shared.current.borders.cornerTopRight.size().width * scale,
                y: maxY
            ),
            zPosition: 2
        )

        topBorder = makeNode(
            texture: ThemeManager.shared.current.borders.borderTop,
            position: CGPoint(x: minX, y: maxY),
            xScale: sceneSize.width
        )
        
        middleBorder = makeNode(
            texture: ThemeManager.shared.current.borders.borderMiddle,
            position: CGPoint(
                x: minX,
                y: topBorder.frame.minY - scale * 33
            ),
            xScale: sceneSize.width,
            zPosition: 2
        )
        
        bottomBorder = makeNode(
            texture: ThemeManager.shared.current.borders.borderBottom,
            position: CGPoint(
                x: minX,
                y: minY + ThemeManager.shared.current.borders.borderBottom.size().height * scale
            ),
            xScale: sceneSize.width
        )
        
        middleLeftCorner = makeNode(
            texture: ThemeManager.shared.current.borders.cornerMiddleLeft,
            position: CGPoint(x: minX, y: middleBorder.position.y),
            zPosition: 3
        )

        middleRightCorner = makeNode(
            texture: ThemeManager.shared.current.borders.cornerMiddleRight,
            position: CGPoint(
                x: maxX - ThemeManager.shared.current.borders.cornerMiddleRight.size().width * scale,
                y: middleBorder.position.y
            ),
            zPosition: 3
        )
        
        topLeftBorder = makeNode(
            texture: ThemeManager.shared.current.borders.borderTopLeft,
            position: CGPoint(x: minX, y: maxY),
            yScale: maxY - middleLeftCorner.position.y
        )

        topRightBorder = makeNode(
            texture: ThemeManager.shared.current.borders.borderTopRight,
            position: CGPoint(
                x: maxX - ThemeManager.shared.current.borders.borderTopRight.size().width * scale,
                y: maxY
            ),
            yScale: maxY - middleRightCorner.position.y
        )

        leftBorder = makeNode(
            texture: ThemeManager.shared.current.borders.borderLeft,
            position: CGPoint(x: minX, y: maxY - topLeftBorder.size.height),
            yScale: middleLeftCorner.position.y - minY
        )

        rightBorder = makeNode(
            texture: ThemeManager.shared.current.borders.borderRight,
            position: CGPoint(
                x: maxX - ThemeManager.shared.current.borders.borderRight.size().width * scale,
                y: maxY - topRightBorder.size.height
            ),
            yScale: middleRightCorner.position.y - minY
        )
        
        bottomLeftCorner = makeNode(
            texture: ThemeManager.shared.current.borders.cornerBottomLeft,
            position: CGPoint(x: minX, y: bottomBorder.position.y)
        )

        bottomRightCorner = makeNode(
            texture: ThemeManager.shared.current.borders.cornerBottomRight,
            position: CGPoint(
                x: maxX - ThemeManager.shared.current.borders.cornerBottomRight.size().width * scale,
                y: bottomBorder.position.y
            )
        )
        
        filler = makeNode(
            texture: ThemeManager.shared.current.borders.filler,
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
    func updateTextures(to theme: Theme) {
        background.texture = theme.borders.filler
        topLeftCorner.texture = theme.borders.cornerTopLeft
        topRightCorner.texture = theme.borders.cornerTopRight
        topBorder.texture = theme.borders.borderTop
        middleBorder.texture = theme.borders.borderMiddle
        bottomBorder.texture = theme.borders.borderBottom
        middleLeftCorner.texture = theme.borders.cornerMiddleLeft
        middleRightCorner.texture = theme.borders.cornerMiddleRight
        topLeftBorder.texture = theme.borders.borderTopLeft
        topRightBorder.texture = theme.borders.borderTopRight
        leftBorder.texture = theme.borders.borderLeft
        rightBorder.texture = theme.borders.borderRight
        bottomLeftCorner.texture = theme.borders.cornerBottomLeft
        bottomRightCorner.texture = theme.borders.cornerBottomRight
        filler.texture = theme.borders.filler
    }
    
    /// Force update the size of all nodes. Called when the scale setting is changed, or the Zoom button is pressed
    func updateScale(sceneSize: CGSize, scale: CGFloat) {
        self.sceneSize = sceneSize
        self.scale = scale
        
        self.removeAllChildren()
        addNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
