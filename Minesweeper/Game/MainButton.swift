//
//  MainButton.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/23/25.
//

import Foundation
import GameplayKit

class MainButton: SKSpriteNode {
    
    var sceneSize: CGSize
    var scale: CGFloat
    
    init(sceneSize: CGSize, scale: CGFloat) {
        self.sceneSize = sceneSize
        self.scale = scale
        super.init(texture: ThemeManager.shared.currentTheme.mainButton.happy, color: .clear, size: ThemeManager.shared.currentTheme.mainButton.happy.size())
        
        addNodes()
    }
    
    private func addNodes() {
        self.position = CGPoint(
            x: -ThemeManager.shared.currentTheme.mainButton.happy.size().width / 2 * scale,
            y: sceneSize.height/2 - (scale * 15)
        )
        
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.setScale(scale)
        self.name = "Main Button"
    }
    
    func set(texture: SKTexture) {
        self.texture = texture
    }
    
    func updateTextures() {
        self.texture = ThemeManager.shared.currentTheme.mainButton.happy
    }
    
    func updateScale(sceneSize: CGSize, scale: CGFloat) {
        self.sceneSize = sceneSize
        self.scale = scale
        
        addNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
