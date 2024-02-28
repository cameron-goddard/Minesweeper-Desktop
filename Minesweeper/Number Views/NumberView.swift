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
    
    var borders = SKSpriteNode(texture: Util.currentTheme.borders.borderNumbers)
    
    init() {
        borders.anchorPoint = CGPoint(x: 0, y: 1)
        borders.setScale(Util.scale)
        node.addChild(borders)
        
        nodeHundreds.anchorPoint = CGPoint(x: 0, y: 1)
        nodeHundreds.setScale(Util.scale)
        nodeHundreds.position = CGPoint(x: 2 * Util.scale, y: -2 * Util.scale)
        node.addChild(nodeHundreds)
        
        nodeTens.anchorPoint = CGPoint(x: 0, y: 1)
        nodeTens.setScale(Util.scale)
        nodeTens.position = CGPoint(x: nodeHundreds.size.width + 4 * Util.scale, y: -2 * Util.scale)
        node.addChild(nodeTens)
        
        nodeOnes.anchorPoint = CGPoint(x: 0, y: 1)
        nodeOnes.setScale(Util.scale)
        nodeOnes.position = CGPoint(x: (2 * nodeHundreds.size.width) + 6 * Util.scale, y: -2 * Util.scale)
        node.addChild(nodeOnes)
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
        self.borders.texture = Util.currentTheme.borders.borderNumbers
    }
}
