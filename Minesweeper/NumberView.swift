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
    var nodeHundreds = SKSpriteNode(texture: Resources.numbers.digits[0])
    var nodeTens = SKSpriteNode(texture: Resources.numbers.digits[0])
    var nodeOnes = SKSpriteNode(texture: Resources.numbers.digits[0])
    
    var borderTop = SKSpriteNode(imageNamed: "number_border_top")
    var borderBottom = SKSpriteNode(imageNamed: "number_border_bottom")
    var borderLeft = SKSpriteNode(imageNamed: "number_border_left")
    var borderRight = SKSpriteNode(imageNamed: "number_border_right")
    
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
        nodeOnes.position = CGPoint(x: Util.scale*nodeTens.size.width, y: nodeOnes.position.y)
        node.addChild(nodeOnes)
        
        borderTop.anchorPoint = CGPoint(x: 0, y: 1)
        borderTop.texture?.filteringMode = .nearest
        borderTop.setScale(Util.scale)
        borderTop.position = CGPoint(x: nodeHundreds.position.x-Util.scale, y: nodeOnes.position.y+Util.scale)
        node.addChild(borderTop)
        
        borderBottom.anchorPoint = CGPoint(x: 0, y: 1)
        borderBottom.texture?.filteringMode = .nearest
        borderBottom.setScale(Util.scale)
        borderBottom.position = CGPoint(x: nodeHundreds.position.x-Util.scale, y: nodeOnes.position.y-nodeOnes.size.height)
        node.addChild(borderBottom)
        
        borderLeft.anchorPoint = CGPoint(x: 0, y: 1)
        borderLeft.texture?.filteringMode = .nearest
        borderLeft.setScale(Util.scale)
        borderLeft.position = CGPoint(x: nodeHundreds.position.x-Util.scale, y: nodeOnes.position.y)
        node.addChild(borderLeft)
        
        borderRight.anchorPoint = CGPoint(x: 0, y: 1)
        borderRight.texture?.filteringMode = .nearest
        borderRight.setScale(Util.scale)
        borderRight.position = CGPoint(x: nodeOnes.position.x+nodeOnes.size.width, y: nodeOnes.position.y)
        node.addChild(borderRight)
    }
    
    func set(value: Int) {
        if (value < 0) {
            nodeHundreds.texture = Resources.numbers.digits.last
            nodeTens.texture = Resources.numbers.digits[(abs(value)/10) % 10]
            nodeOnes.texture = Resources.numbers.digits[abs(value) % 10]
        } else {
            nodeHundreds.texture = Resources.numbers.digits[(value/100) % 10]
            nodeTens.texture = Resources.numbers.digits[(value/10) % 10]
            nodeOnes.texture = Resources.numbers.digits[value % 10]
        }
    }
}
