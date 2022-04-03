//
//  Board.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import Foundation
import SpriteKit

class Board {
    
    let node: SKShapeNode
    
    let rows: Int
    let cols: Int
    let mines: Int
    
    init(rows: Int, cols: Int, mines: Int) {
        self.node = SKShapeNode()
        
        self.rows = rows
        self.cols = cols
        self.mines = mines
    }
    
}
