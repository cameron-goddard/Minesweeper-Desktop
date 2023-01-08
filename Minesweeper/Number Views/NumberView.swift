//
//  NumberView.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 5/28/22.
//

import Foundation
import SpriteKit

class NumberView {
    
    var node = SKSpriteNode()
    var nodeHundreds = SKSpriteNode(texture: Util.currentTheme.numbers.digits[0])
    var nodeTens = SKSpriteNode(texture: Util.currentTheme.numbers.digits[0])
    var nodeOnes = SKSpriteNode(texture: Util.currentTheme.numbers.digits[0])
    
    var borderTop = SKSpriteNode(texture: Util.currentTheme.borders.numberBorderTop)
    var borderBottom = SKSpriteNode(texture: Util.currentTheme.borders.numberBorderBottom)
    var borderLeft = SKSpriteNode(texture: Util.currentTheme.borders.numberBorderLeft)
    var borderRight = SKSpriteNode(texture: Util.currentTheme.borders.numberBorderRight)
    
    init() {
        nodeHundreds.anchorPoint = CGPoint(x: 0, y: 1)
        nodeHundreds.setScale(Util.scale)
        node.addChild(nodeHundreds)
        
        nodeTens.anchorPoint = CGPoint(x: 0, y: 1)
        nodeTens.setScale(Util.scale)
        nodeTens.position = CGPoint(x: nodeHundreds.size.width, y: nodeTens.position.y)
        node.addChild(nodeTens)
        
        nodeOnes.anchorPoint = CGPoint(x: 0, y: 1)
        nodeOnes.setScale(Util.scale)
        nodeOnes.position = CGPoint(x: 2*nodeTens.size.width, y: nodeOnes.position.y)
        node.addChild(nodeOnes)
        
        borderTop.anchorPoint = CGPoint(x: 0, y: 1)
        borderTop.setScale(Util.scale)
        borderTop.position = CGPoint(x: nodeHundreds.position.x-Util.scale, y: nodeOnes.position.y+Util.scale)
        node.addChild(borderTop)
        
        borderBottom.anchorPoint = CGPoint(x: 0, y: 1)
        borderBottom.setScale(Util.scale)
        borderBottom.position = CGPoint(x: nodeHundreds.position.x-Util.scale, y: nodeOnes.position.y-nodeOnes.size.height)
        node.addChild(borderBottom)
        
        borderLeft.anchorPoint = CGPoint(x: 0, y: 1)
        borderLeft.setScale(Util.scale)
        borderLeft.position = CGPoint(x: nodeHundreds.position.x-Util.scale, y: nodeOnes.position.y)
        node.addChild(borderLeft)
        
        borderRight.anchorPoint = CGPoint(x: 0, y: 1)
        borderRight.setScale(Util.scale)
        borderRight.position = CGPoint(x: nodeOnes.position.x+nodeOnes.size.width, y: nodeOnes.position.y)
        node.addChild(borderRight)
    }
    
    func set(value: Int) {
        if (value < 0) {
            nodeHundreds.texture = Util.currentTheme.numbers.digits.last
            nodeTens.texture = Util.currentTheme.numbers.digits[(abs(value)/10) % 10]
            nodeOnes.texture = Util.currentTheme.numbers.digits[abs(value) % 10]
        } else {
            nodeHundreds.texture = Util.currentTheme.numbers.digits[(value/100) % 10]
            nodeTens.texture = Util.currentTheme.numbers.digits[(value/10) % 10]
            nodeOnes.texture = Util.currentTheme.numbers.digits[value % 10]
        }
    }
    
    func setTextures() {
        self.borderLeft.texture = Util.currentTheme.borders.numberBorderLeft
        self.borderRight.texture = Util.currentTheme.borders.numberBorderRight
        self.borderBottom.texture = Util.currentTheme.borders.numberBorderBottom
        self.borderTop.texture = Util.currentTheme.borders.numberBorderTop
    }
}
