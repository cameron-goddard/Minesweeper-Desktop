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
    
    let rows, cols, mines : Int
    
    var revealedTiles = 0
    var availableTiles : Int
    
    var tiles : [[Tile]] //may change this
    
    private var tileSize: CGSize {
        CGSize(
            width: 16*Util.scale,
            height: 16*Util.scale
        )
    }
    
    init(rows: Int, cols: Int, mines: Int) {
        self.node = SKShapeNode(path: CGPath(rect: CGRect(x: 0, y: 0, width: cols*16*Int(Util.scale), height: rows*16*Int(Util.scale)), transform: nil), centered: true)
        self.node.lineWidth = 0
        
        self.availableTiles = rows*cols - mines
        
        self.rows = rows
        self.cols = cols
        self.mines = mines
        
        self.tiles = [[Tile]](repeating: [Tile](repeating: Tile(), count: cols), count: rows)
        initBoard()
    }
    
    private func initBoard() {
        // init tiles
        for r in 0...rows-1 {
            for c in 0...cols-1 {
                let tile = Tile(r: r, c: c, state: .Covered)
                self.tiles[r][c] = tile
                node.addChild(tile.node)
            }
        }
        
        // set tile sizes and positions
        for r in 0...rows-1 {
            for c in 0...cols-1 {
                tiles[r][c].node.size = tileSize
                
                let x = node.frame.minX + CGFloat(c) * tileSize.width
                let y = node.frame.maxY - CGFloat(r) * tileSize.height
                
                tiles[r][c].node.position = CGPoint(x: x-CGFloat((4*cols)), y: y+CGFloat((4*rows))-(Util.scale*21.5)) //Temporary fix
            }
        }
        
        // add mines
        var addedMines = 0
        while addedMines < mines {
            for r in 0...rows-1 {
                for c in 0...cols-1 {
                    if Int.random(in: 0...100) == 0 && tiles[r][c].value == .Empty && addedMines < mines {
                        tiles[r][c].setValue(val: .Mine)
                        addedMines += 1
                    }
                }
            }
        }
        
        // set adjacency numbers
        setNumbers()
    }
    
    private func numberOfAdjacentMines(r: Int, c: Int) -> Int {
        var ret = 0
        for tile in getAdjacentTiles(r: r, c: c) {
            if tile.value == .Mine {
                ret += 1
            }
        }
        return ret
    }

    private func getAdjacentTiles(r: Int, c: Int) -> [Tile] {
        var ret = [Tile]()
        if let tile = tileAt(r: r-1, c: c) { ret.append(tile)}
        if let tile = tileAt(r: r-1, c: c-1) { ret.append(tile)}
        if let tile = tileAt(r: r-1, c: c+1) { ret.append(tile)}
        if let tile = tileAt(r: r, c: c-1) { ret.append(tile)}
        if let tile = tileAt(r: r, c: c+1) { ret.append(tile)}
        if let tile = tileAt(r: r+1, c: c) { ret.append(tile)}
        if let tile = tileAt(r: r+1, c: c-1) { ret.append(tile)}
        if let tile = tileAt(r: r+1, c: c+1) { ret.append(tile)}
        return ret
    }
    
    private func setNumbers() {
        for r in 0...rows-1 {
            for c in 0...cols-1 {
                if (tileAt(r: r, c: c)!.value != .Mine) {
                    switch numberOfAdjacentMines(r: r, c: c) {
                    case 1:
                        tiles[r][c].setValue(val: .One)
                    case 2:
                        tiles[r][c].setValue(val: .Two)
                    case 3:
                        tiles[r][c].setValue(val: .Three)
                    case 4:
                        tiles[r][c].setValue(val: .Four)
                    case 5:
                        tiles[r][c].setValue(val: .Five)
                    case 6:
                        tiles[r][c].setValue(val: .Six)
                    case 7:
                        tiles[r][c].setValue(val: .Seven)
                    case 8:
                        tiles[r][c].setValue(val: .Eight)
                    default:
                        tiles[r][c].setValue(val: .Empty)
                    }
                }
            }
        }
    }
    
    func revealAt(r: Int, c: Int) -> Bool {
        let tile = tiles[r][c]
        print("[" + String(r) + ", " + String(c) + "]")
        
        if tile.state != .Uncovered {
            if tile.value == .Empty {
                reveal(r: r, c: c)
            } else {
                if revealedTiles == 0 && Util.userDefault(withKey: .SafeFirstClick) as! Bool && tile.value == .Mine {
                    
                    let allTiles = getAdjacentTiles(r: tile.r, c: tile.c) + [tile]
                    
                    allTiles.forEach { adjTile in
                        createBlankFrom(row: adjTile.r, col: adjTile.c, avoid: allTiles)
                    }
                    setNumbers()
                    reveal(r: r, c: c)
                } else {
                    tile.setState(state: .Uncovered)
                    revealedTiles += 1
                }
            }
        }
        
        if tile.value == .Mine {
            tile.setValue(val: .MineRed)
            tile.setState(state: .Uncovered)
            revealedTiles += 1
            return true
        }
        return false
    }
    
    private func reveal(r: Int, c: Int) {
        tiles[r][c].setState(state: .Uncovered)
        revealedTiles += 1
        
        for tile in getAdjacentTiles(r: r, c: c) {
            if tile.isNumber() {
                if tiles[tile.r][tile.c].state != .Uncovered {
                    tiles[tile.r][tile.c].setState(state: .Uncovered)
                    revealedTiles += 1
                }
            }
            if tile.value == .Empty && tile.state == .Covered {
                reveal(r: tile.r, c: tile.c)
            }
        }
    }
    
    func setAt(r: Int, c: Int, state: State) {
        let tile = tiles[r][c]
        
        switch state {
        case .Covered:
            tile.setState(state: .Covered)
        case .Uncovered:
            tile.setState(state: .Uncovered)
            revealedTiles += 1
        case .Flagged:
            tile.setState(state: .Flagged)
        case .Question:
            tile.setState(state: .Question)
        }
    }
    
    func tileAt(r: Int, c: Int) -> Tile? {
        if r < 0 || r > rows-1 || c < 0 || c > cols-1 {
            return nil
        }
        return tiles[r][c]
    }
    
    func lostGame() {
        for r in 0...rows-1 {
            for c in 0...cols-1 {
                let tile = tiles[r][c]
                if tile.state == .Flagged && tile.value != .Mine {
                    tile.setValue(val: .MineWrong)
                }
                if (tile.value == .Mine && tile.state != .Flagged) || tile.value == .MineWrong {
                    tile.setState(state: .Uncovered)
                }
            }
        }
    }
    
    func reset() {
        initBoard()
    }
    
    func flagMines() {
        for r in 0...rows-1 {
            for c in 0...cols-1 {
                let tile = tiles[r][c]
                
                if tile.value == .Mine && tile.state != .Flagged {
                    tile.setState(state: .Flagged)
                }
            }
        }
    }
    
    private func createBlankFrom(row: Int, col: Int, avoid: [Tile]) {
        if tiles[row][col].value != .Mine {
            return
        }
        tiles[row][col].setValue(val: .Empty)
        var new = tiles[Int.random(in: 0..<rows-1)][Int.random(in: 0..<cols-1)]
        
        while new.value != .Empty || avoid.contains(new) {
            new = tiles[Int.random(in: 0..<rows-1)][Int.random(in: 0..<cols-1)]
        }
        new.setValue(val: .Mine)
    }
}
