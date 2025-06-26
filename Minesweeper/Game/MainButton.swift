//
//  MainButton.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/23/25.
//

import Foundation
import GameplayKit

class MainButton: SKSpriteNode {
    
    enum State {
        case Happy
        case HappyPressed
        case Cautious
        case Cool
        case Dead
    }
    
    var state: State
    var sceneSize: CGSize
    var scale: CGFloat
    
    init(sceneSize: CGSize, scale: CGFloat) {
        self.sceneSize = sceneSize
        self.scale = scale
        self.state = .Happy
        
        super.init(texture: ThemeManager.shared.current.mainButton.happy, color: .clear, size: ThemeManager.shared.current.mainButton.happy.size())
        
        addNodes()
    }
    
    private func addNodes() {
        self.position = CGPoint(
            x: -ThemeManager.shared.current.mainButton.happy.size().width / 2 * scale,
            y: sceneSize.height/2 - (scale * 15)
        )
        
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.setScale(scale)
        self.name = "Main Button"
    }
    
    func set(state: State) {
        self.state = state
        updateTextures()
    }
    
    /// Force update the node's texture. Called when a theme is changed
    func updateTextures() {
        switch state {
        case .Happy:
            self.texture = ThemeManager.shared.current.mainButton.happy
        case .HappyPressed:
            self.texture = ThemeManager.shared.current.mainButton.happyPressed
        case .Cautious:
            self.texture = ThemeManager.shared.current.mainButton.cautious
        case .Cool:
            self.texture = ThemeManager.shared.current.mainButton.cool
        case .Dead:
            self.texture = ThemeManager.shared.current.mainButton.dead
        }
    }
    
    /// Force update the size of the node. Called when the scale setting is changed, or the Zoom button is pressed
    func updateScale(sceneSize: CGSize, scale: CGFloat) {
        self.sceneSize = sceneSize
        self.scale = scale
        
        addNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
