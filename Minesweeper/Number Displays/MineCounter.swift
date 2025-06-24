//
//  MineCounter.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/9/22.
//

import Foundation
import SpriteKit

class MineCounter: NumberDisplay {
    
    var mines: Int
    
    init(sceneSize: CGSize, scale: CGFloat, mines: Int) {
        self.mines = mines
        super.init(sceneSize: sceneSize, scale: scale)
        self.set(value: mines)
        self.position = CGPoint(x: -sceneSize.width/2 + 16 * scale, y: sceneSize.height/2 - (scale * 15))
    }
    
    func increment() {
        mines += 1
        self.set(value: mines)
    }
    
    func decrement() {
        mines -= 1
        self.set(value: mines)
    }
    
    func reset(mines: Int) {
        self.mines = mines
        self.set(value: mines)
    }
    
    /// Force update all textures. Called when a theme is changed
    override func updateTextures() {
        super.updateTextures()
        self.set(value: mines)
    }
    
    override func updateScale(sceneSize: CGSize, scale: CGFloat) {
        super.updateScale(sceneSize: sceneSize, scale: scale)
        self.position = CGPoint(x: -sceneSize.width/2 + 16 * scale, y: sceneSize.height/2 - (scale * 15))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

