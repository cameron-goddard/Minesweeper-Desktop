//
//  Board.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import Foundation
import SpriteKit
import Defaults

/// Representation of a Minesweeper board
class Board {
    
    /// The anchor node for the board
    let node: SKShapeNode
    
    /// Board size and density
    let rows, cols, mines : Int
    
    /// Tiles representation
    private var tiles : [[Tile]]
    
    /// Coordinates for all mines on the board
    var minesLayout: [(Int, Int)] = []
    
    /// Counter to keep track of game progress
    var revealedTiles = 0
    
    /// Whether this board layout was specifically loaded vs randomly generated
    private var loadedBoard: Bool = false
    
    private var tileSize: CGSize {
        CGSize(
            width: 16 * Util.scale,
            height: 16 * Util.scale
        )
    }
    
    init(rows: Int, cols: Int, mines: Int, minesLayout: [(Int, Int)]?) {
        self.node = SKShapeNode(path: CGPath(rect: CGRect(x: 0, y: 0, width: cols * 16 * Int(Util.scale), height: rows * 16 * Int(Util.scale)), transform: nil), centered: true)
        self.node.lineWidth = 0
        
        self.rows = rows
        self.cols = cols
        self.mines = mines
        
        // Mark this as a loaded board if given a predefined mine layout
        if minesLayout != nil {
            self.minesLayout = minesLayout!
            self.loadedBoard = true
        }
        
        self.tiles = [[Tile]](repeating: [Tile](repeating: Tile(), count: cols), count: rows)
        initBoard()
    }
    
    /// Adds tiles to the anchor node. Sets mines and numbers. Calculates total 3BV
    /// - Parameter restart: Whether the previously played board is being reloaded
    private func initBoard(restart: Bool = false) {
        // Init tiles
        for r in 0..<rows {
            for c in 0..<cols {
                let tile = Tile(r: r, c: c, state: .Covered)
                self.tiles[r][c] = tile
                node.addChild(tile.node)
            }
        }
        
        // Set tile sizes and positions
        let originX = -(CGFloat(cols) * tileSize.width) / 2
        let originY = (CGFloat(rows) * tileSize.height) / 2

        for r in 0..<rows {
            for c in 0..<cols {
                let x = originX + CGFloat(c) * tileSize.width
                let y = originY - CGFloat(r) * tileSize.height - (21.5 * Util.scale)

                tiles[r][c].node.size = tileSize
                tiles[r][c].node.position = CGPoint(x: x, y: y)
            }
        }
        
        // Add mines
        if loadedBoard || restart {
            for (r, c) in minesLayout {
                tiles[r][c].setValue(val: .Mine)
            }
        } else {
            minesLayout = []
            
            var addedMines = 0
            while addedMines < mines {
                for r in 0..<rows {
                    for c in 0..<cols {
                        if Int.random(in: 0...100) == 0 && tiles[r][c].value == .Empty && addedMines < mines {
                            tiles[r][c].setValue(val: .Mine)
                            minesLayout.append((r, c))
                            addedMines += 1
                        }
                    }
                }
            }
        }
        
        // Set adjacency numbers
        setNumbers()
        
        // Calculate total 3BV and send to Stats
        NotificationCenter.default.post(name: .updateStat, object: "test", userInfo: ["Total3BV": calculate3BV()])
    }
    
    /// Force update tile textures. Called when a theme is changed
    func setTextures() {
        for r in 0..<rows {
            for c in 0..<cols {
                let tile = tileAt(r: r, c: c)!
                tile.setState(state: tile.state)
            }
        }
    }
    
    /// Returns a list of the adjacent tiles to a target tile
    /// - Parameters:
    ///   - r: The row of the target tile
    ///   - c: The column of the target tile
    /// - Returns: A list of the adjacent tiles
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
    
    /// Returns the number of adjacent mines to a target tile
    /// - Parameters:
    ///   - r: The row of the target tile
    ///   - c: The column of the target tile
    /// - Returns: The number of adjacent mines
    private func numberOfAdjacentMines(r: Int, c: Int) -> Int {
        var ret = 0
        for tile in getAdjacentTiles(r: r, c: c) {
            if tile.value == .Mine {
                ret += 1
            }
        }
        return ret
    }
    
    /// Sets the adjacency numbers for every tile on the board
    private func setNumbers() {
        for r in 0..<rows {
            for c in 0..<cols {
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
    
    /// Reveals the tile at the specified target, including any adjacent blanks
    /// - Parameters:
    ///   - r: The row of the target tile
    ///   - c: The column of the target tile
    /// - Returns: True if the revelaed tile is a mine, false otherwise
    func revealAt(r: Int, c: Int) -> Bool {
        let tile = tiles[r][c]
        print("[" + String(r) + ", " + String(c) + "]")
        
        if tile.state != .Uncovered {
            NotificationCenter.default.post(name: .updateStat, object: "Effective", userInfo: ["Effective": 0])
            
            if tileAt(r: r, c: c)?.value == .Empty || (tileAt(r: r, c: c)?.value != .Mine && !getAdjacentTiles(r: r, c: c).contains(where: { $0.value == .Empty })) {
                NotificationCenter.default.post(name: .updateStat, object: "3BV", userInfo: ["3BV": 0])
            }
            
            if tile.value == .Empty {
                reveal(r: r, c: c)
            } else {
                if revealedTiles == 0 && Defaults[.safeFirstClick] && tile.value == .Mine && !loadedBoard {
                    
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
        } else {
            NotificationCenter.default.post(name: .updateStat, object: 0, userInfo: ["NonEffective": 0])
        }
        
        NotificationCenter.default.post(name: .updateStat, object: "Left", userInfo: ["Left": 0])
        
        if tile.value == .Mine {
            tile.setValue(val: .MineRed)
            tile.setState(state: .Uncovered)
            revealedTiles += 1
            return true
        }
        return false
    }
    
    /// Recursively reveals a blank section of tiles
    /// - Parameters:
    ///   - r: The row of the current file to reveal at
    ///   - c: The column of the current tile to reveal at
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
    
    /// Sets the state of the specified tile. Updates the number of revealed tiles if necessary
    /// - Parameters:
    ///   - r: The row of the target tile
    ///   - c: The column of the target tile
    ///   - state: The new state of the tile
    func setAt(r: Int, c: Int, state: State) {
        tiles[r][c].setState(state: state)
        if state == .Uncovered {
            revealedTiles += 1
        }
    }
    
    /// Returns the tile at a specified position, if it exists
    /// - Parameters:
    ///   - r: The row of the target tile
    ///   - c: The column of the target tile
    /// - Returns: The specified tile if it exists, or nil otherwise
    func tileAt(r: Int, c: Int) -> Tile? {
        if r < 0 || r > rows-1 || c < 0 || c > cols-1 {
            return nil
        }
        return tiles[r][c]
    }
    
    /// Uncovers all mines and marks incorrectly flagged mines. Called when a player loses a game
    func lostGame() {
        for r in 0..<rows {
            for c in 0..<cols {
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
    
    /// Re-initializes the board in a randomly generated way
    func reset() {
        loadedBoard = false
        initBoard()
    }
    
    /// Restarts the last played board
    func restart() {
        initBoard(restart: true)
    }
    
    /// Flags all mines that are not already flagged. Called when a player wins a games
    func flagMines() {
        for r in 0..<rows {
            for c in 0..<cols {
                let tile = tiles[r][c]
                
                if tile.value == .Mine && tile.state != .Flagged {
                    tile.setState(state: .Flagged)
                }
            }
        }
    }
    
    /// Creates a new blank space from a tile with a mine on it. Called when the "Guarantee safe first click" setting is enabled
    /// - Parameters:
    ///   - row: The row of the target tile
    ///   - col: The column of the target tile
    ///   - avoid: A list of tiles to avoid putting a mine on
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
        
        minesLayout.removeAll(where: { $0 == (row, col) })
        minesLayout.append((new.r, new.c))
    }
}

extension Board {
    
    /// Helper method for calculating 3BV
    /// - Parameters:
    ///   - marked: The list of already-marked tiles
    ///   - x: The row of the current tile to flood fill at
    ///   - y: The column of the current tile to flood fill at
    private func floodFill(marked: inout [[Bool]], r: Int, c: Int) {
        if r < 0 || r >= rows || c < 0 || c >= cols || marked[r][c] {
            return
        }

        marked[r][c] = true

        if tiles[r][c].value != .Empty  {
            return
        }

        let directions = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
        for (dr, dc) in directions {
            floodFill(marked: &marked, r: r + dr, c: c + dc)
        }
    }
    
    /// Calculates the 3BV of the current board
    /// - Returns: The total 3BV value
    private func calculate3BV() -> Int {
        var marked = Array(repeating: Array(repeating: false, count: cols), count: rows)
        var bvCount = 0

        // Count regions of empty tiles
        for r in 0..<rows {
            for c in 0..<cols {
                if tiles[r][c].value == .Empty && !marked[r][c] {
                    bvCount += 1
                    floodFill(marked: &marked, r: r, c: c)
                }
            }
        }

        // Count individually revealed numbered tiles
        for r in 0..<rows {
            for c in 0..<cols {
                if !marked[r][c] && tiles[r][c].isNumber() {
                    bvCount += 1
                }
            }
        }

        return bvCount
    }
}
