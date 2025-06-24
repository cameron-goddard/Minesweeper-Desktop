//
//  GameScene.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import SpriteKit
import GameplayKit
import Defaults

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
    
    var rows, cols, mines: Int
    var scale: CGFloat
    
    var currentTile: String? = nil
    
    init(size: CGSize, scale: CGFloat, rows: Int, cols: Int, mines: Int, minesLayout: [(Int, Int)]?) {
        self.rows = rows
        self.cols = cols
        self.mines = mines
        self.scale = scale
        
        borders = Borders(sceneSize: size, scale: scale)
        board = Board(scale: scale, rows: rows, cols: cols, mines: mines, minesLayout: minesLayout)
        mainButton = MainButton(sceneSize: size, scale: scale)
        gameTimer = GameTimer(sceneSize: size, scale: scale)
        mineCounter = MineCounter(sceneSize: size, scale: scale, mines: mines)
        
        super.init(size: size)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.restartGame(_:)), name: .restartGame, object: nil)
    }
    
    /// Creates the game board, counters, and borders with the current theme. Adds all to this game scene
    func addNodes() {
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
    
    func updateScale(size: CGSize, scale: CGFloat) {
        self.scale = scale
        
        borders.updateScale(sceneSize: size, scale: scale)
        mainButton.updateScale(sceneSize: size, scale: scale)
        board.updateScale(scale: scale)
        gameTimer.updateScale(sceneSize: size, scale: scale)
        mineCounter.updateScale(sceneSize: size, scale: scale)
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
            mainButton.set(texture: ThemeManager.shared.currentTheme.mainButton.cool)
        } else {
            gameState = .Lost
            board.lostGame()
            mainButton.set(texture: ThemeManager.shared.currentTheme.mainButton.dead)
        }
        gameTimer.stopTimer()
    }
    
    func newGame(restart: Bool = false) {
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
