//
//  GameScene.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var board: Board!
    var borders: Borders!
    var timerView: TimerView!
    var counterView: CounterView!
    
    var mainButton: SKSpriteNode!
    
    var rows, cols, mines : Int
    
    var gameOver = false
    var gameStarted = false
    
    var currentTile: String? = nil
    
    init(size: CGSize, rows: Int, cols: Int, mines: Int, minesLayout: [(Int, Int)]?) {
        self.rows = rows
        self.cols = cols
        self.mines = mines
        
        borders = Borders(size: size)
        board = Board(rows: rows, cols: cols, mines: mines, minesLayout: minesLayout)
        timerView = TimerView()
        counterView = CounterView(mines: self.mines)
        
        super.init(size: size)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.restartGame(_:)), name: .restartGame, object: nil)
    }
    
    /// Creates the game board, counters, and borders with the current theme. Adds all to this game scene
    func addNodes() {
        mainButton = SKSpriteNode(texture: Util.currentTheme.mainButton.happy)
        mainButton.anchorPoint = CGPoint(x: 0, y: 1)
        mainButton.setScale(Util.scale)
        mainButton.position = CGPoint(
            x: -Util.currentTheme.mainButton.happy.size().width/2 * Util.scale,
            y: self.frame.maxY - (Util.scale * 15)
        )
        mainButton.name = "Main Button"
        
        counterView.position = CGPoint(x: self.frame.minX + 16 * Util.scale, y: mainButton.position.y)
        timerView.position = CGPoint(x: self.frame.maxX - 57 * Util.scale, y: mainButton.position.y)
        
        self.addChild(borders)
        self.addChild(mainButton)
        self.addChild(counterView)
        self.addChild(timerView)
        self.addChild(board.node)
    }
    
    func updateTextures() {
        mainButton.texture = Util.currentTheme.mainButton.happy
        
        borders.updateTextures()
        board.updateTextures()
        timerView.updateTextures()
        counterView.updateTextures()
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addNodes()
    }
    
    func finishGame(won: Bool) {
        gameOver = true
        gameStarted = false
        NotificationCenter.default.post(name: .revealStats, object: nil)
        
        if won {
            board.flagMines()
            mainButton.texture = Util.currentTheme.mainButton.cool
        } else {
            board.lostGame()
            mainButton.texture = Util.currentTheme.mainButton.dead
        }
        timerView.stopTimer()
    }
    
    func newGame() {
        board.revealedTiles = 0
        gameOver = false
        gameStarted = false
        NotificationCenter.default.post(name: .resetStats, object: nil)
        
        board.reset()
        timerView.reset()
        counterView.reset(mines: self.mines)
    }
    
    @objc func restartGame(_ notification: Notification) {
        board.revealedTiles = 0
        gameOver = false
        gameStarted = false
        NotificationCenter.default.post(name: .resetStats, object: nil)
        
        board.restart()
        timerView.reset()
        counterView.reset(mines: self.mines)
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
