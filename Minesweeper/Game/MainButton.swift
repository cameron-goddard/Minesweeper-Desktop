//
//  MainButton.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/23/25.
//

import Foundation
import GameplayKit

class MainButton: SKSpriteNode {
    
    init() {
        super.init(texture: ThemeManager.shared.currentTheme.mainButton.happy, color: .clear, size: ThemeManager.shared.currentTheme.mainButton.happy.size())
        
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.setScale(Util.scale)
        self.name = "Main Button"
    }
    
    func set(texture: SKTexture) {
        self.texture = texture
    }
    
    func updateTextures() {
        self.texture = ThemeManager.shared.currentTheme.mainButton.happy
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
