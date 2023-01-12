//
//  CounterView.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/9/22.
//

import Foundation
import SpriteKit

class CounterView: NumberView {
    
    var mines: Int
    
    init(mines: Int) {
        self.mines = mines
        super.init()
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
    
    override func setTextures() {
        super.setTextures()
        self.set(value: mines)
    }
    
}

