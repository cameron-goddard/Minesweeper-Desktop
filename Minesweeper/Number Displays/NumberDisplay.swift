//
//  NumberDisplay.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 5/28/22.
//

import Foundation
import SpriteKit

class NumberDisplay: SKNode {
    
    var borders: SKSpriteNode
    var nodeHundreds: SKSpriteNode
    var nodeTens: SKSpriteNode
    var nodeOnes: SKSpriteNode
    
    var sceneSize: CGSize
    var scale: CGFloat
    
    init(sceneSize: CGSize, scale: CGFloat) {
        self.sceneSize = sceneSize
        self.scale = scale
        
        borders = SKSpriteNode(texture: ThemeManager.shared.current.borders.borderNumbers)
        nodeHundreds = SKSpriteNode(texture: ThemeManager.shared.current.numbers.digits[0])
        nodeTens = SKSpriteNode(texture: ThemeManager.shared.current.numbers.digits[0])
        nodeOnes = SKSpriteNode(texture: ThemeManager.shared.current.numbers.digits[0])
        
        super.init()
        addNodes()
    }
    
    func addNodes() {
        [borders, nodeHundreds, nodeTens, nodeOnes].forEach {
            $0.anchorPoint = CGPoint(x: 0, y: 1)
            $0.setScale(scale)
        }
        
        nodeHundreds.position = CGPoint(x: 2 * scale, y: -2 * scale)
        nodeTens.position = CGPoint(x: nodeHundreds.size.width + 4 * scale, y: -2 * scale)
        nodeOnes.position = CGPoint(x: (2 * nodeHundreds.size.width) + 6 * scale, y: -2 * scale)
        
        self.addChild(borders)
        self.addChild(nodeHundreds)
        self.addChild(nodeTens)
        self.addChild(nodeOnes)
    }
    
    func set(value: Int, theme: Theme = ThemeManager.shared.current) {
        if (value < 0) {
            nodeHundreds.texture = theme.numbers.digits.last
            nodeTens.texture = theme.numbers.digits[(abs(value)/10) % 10]
            nodeOnes.texture = theme.numbers.digits[abs(value) % 10]
        } else {
            nodeHundreds.texture = theme.numbers.digits[(value/100) % 10]
            nodeTens.texture = theme.numbers.digits[(value/10) % 10]
            nodeOnes.texture = theme.numbers.digits[value % 10]
        }
    }
    
    /// Force update all textures. Called when a theme is changed
    /// - Parameter theme: The theme to update to
    func updateTextures(to theme: Theme) {
        self.borders.texture = theme.borders.borderNumbers
    }
    
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
