//
//  AssetScene.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 1/12/23.
//

import Cocoa
import SpriteKit

class AssetScene: SKScene {

    init(asset: SKTexture) {
        super.init(size: CGSize(width: 71, height: 36))
        let node = SKSpriteNode(texture: asset)
        node.anchorPoint = CGPoint(x: 0, y: 0)
        node.setScale(2)
        self.addChild(node)
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .clear
        self.view?.allowsTransparency = true
        view.layer?.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
