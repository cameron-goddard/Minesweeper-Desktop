//
//  GameScene.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import SpriteKit
import GameplayKit

enum GameState {
    case Unstarted
    case InProgress
    case Won
    case Lost
}

class GameScene: SKScene {
    
    var gameState: GameState = .Unstarted
    
    var board: Board
    var borders: Borders
    var gameTimer: GameTimer
    var mineCounter: MineCounter
    var mainButton: MainButton
    
    var rows, cols, mines : Int
    
    var currentTile: String? = nil
    
    init(size: CGSize, rows: Int, cols: Int, mines: Int, minesLayout: [(Int, Int)]?) {
        self.rows = rows
        self.cols = cols
        self.mines = mines
        
        borders = Borders(size: size)
        board = Board(rows: rows, cols: cols, mines: mines, minesLayout: minesLayout)
        mainButton = MainButton()
        gameTimer = GameTimer()
        mineCounter = MineCounter(mines: mines)
        
        super.init(size: size)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.restartGame(_:)), name: .restartGame, object: nil)
    }
    
    /// Creates the game board, counters, and borders with the current theme. Adds all to this game scene
    func addNodes() {
        
        mainButton.position = CGPoint(
            x: -Util.currentTheme.mainButton.happy.size().width / 2 * Util.scale,
            y: self.frame.maxY - (Util.scale * 15)
        )
        
        mineCounter.position = CGPoint(x: self.frame.minX + 16 * Util.scale, y: mainButton.position.y)
        gameTimer.position = CGPoint(x: self.frame.maxX - 57 * Util.scale, y: mainButton.position.y)
        
        self.addChild(borders)
        self.addChild(mainButton)
        self.addChild(mineCounter)
        self.addChild(gameTimer)
        self.addChild(board.node)
    }
    
    /// Force update all game textures. Called when a theme is changed
    func updateTextures() {
        borders.updateTextures()
        mainButton.updateTextures()
        board.updateTextures()
        gameTimer.updateTextures()
        mineCounter.updateTextures()
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addNodes()
    }
    
    func finishGame(won: Bool) {
        NotificationCenter.default.post(name: .revealStats, object: nil)
        
        if won {
            gameState = .Won
            board.flagMines()
            mainButton.set(texture: Util.currentTheme.mainButton.cool)
        } else {
            gameState = .Lost
            board.lostGame()
            mainButton.set(texture: Util.currentTheme.mainButton.dead)
        }
        gameTimer.stopTimer()
    }
    
    func newGame(restart: Bool = false) {
        board.revealedTiles = 0
        gameState = .Unstarted
        NotificationCenter.default.post(name: .resetStats, object: nil)
        
        board.reset(restart: restart)
        gameTimer.reset()
        mineCounter.reset(mines: self.mines)
    }
    
    @objc func restartGame(_ notification: Notification) {
        newGame(restart: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Notification.Name {
    static let restartGame = Notification.Name("RestartGame")
}
