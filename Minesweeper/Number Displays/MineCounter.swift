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
    
    init(scale: CGFloat, mines: Int) {
        self.mines = mines
        super.init(scale: scale)
        self.set(value: mines)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

