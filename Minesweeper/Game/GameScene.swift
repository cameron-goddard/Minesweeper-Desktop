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
    
    let isThemePreview: Bool
    
    var currentTile: String? = nil
    var isChord = false
    
    init(size: CGSize, scale: CGFloat, rows: Int, cols: Int, mines: Int, minesLayout: [(Int, Int)]?, isThemePreview: Bool = false) {
        self.rows = rows
        self.cols = cols
        self.mines = mines
        self.scale = scale
        self.isThemePreview = isThemePreview
        
        borders = Borders(sceneSize: size, scale: scale)
        board = Board(scale: scale, rows: rows, cols: cols, mines: mines, minesLayout: minesLayout, isThemePreview: isThemePreview)
        mainButton = MainButton(sceneSize: size, scale: scale)
        gameTimer = GameTimer(sceneSize: size, scale: scale)
        mineCounter = MineCounter(sceneSize: size, scale: scale, mines: mines)
        
        super.init(size: size)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.restartGame(_:)), name: .restartGame, object: nil)
    }
    
    /// Creates the game board, number displays, and borders with the current theme. Adds all to this game scene
    func addNodes() {
        self.addChild(borders)
        self.addChild(mainButton)
        self.addChild(mineCounter)
        self.addChild(gameTimer)
        self.addChild(board.node)
        
        if isThemePreview {
            // Add a transparent blocker to prevent user interaction in the themes settings window
            let blocker = SKSpriteNode(color: .clear, size: self.size)
            blocker.position = .zero
            blocker.zPosition = 1000
            self.addChild(blocker)
            
            mineCounter.mines = 7
            gameTimer.elapsedTime = 42
        }
    }
    
    /// Force update all game textures. Called when a theme is changed
    /// - Parameter theme: The theme to update to
    func updateTextures(to theme: Theme = ThemeManager.shared.current) {
        borders.updateTextures(to: theme)
        mainButton.updateTextures(to: theme)
        board.updateTextures(to: theme)
        gameTimer.updateTextures(to: theme)
        mineCounter.updateTextures(to: theme)
    }
    
    /// Force update the size of all nodes. Called when the scale setting is changed, or the Zoom button is pressed
    /// - Parameters:
    ///   - size: The new scene size to adapt to
    ///   - scale: The new scaling for each node
    func updateScale(size: CGSize, scale: CGFloat) {
        self.scale = scale
        
        borders.updateScale(sceneSize: size, scale: scale)
        mainButton.updateScale(sceneSize: size, scale: scale)
        board.updateScale(scale: scale)
        gameTimer.updateScale(sceneSize: size, scale: scale)
        mineCounter.updateScale(sceneSize: size, scale: scale)
    }
    
    /// Called when the scene is presented by a view
    /// - Parameter view: The view that is presenting this scene
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addNodes()
    }
    
    /// Handle game ending logic for the board, main button, and stats
    /// - Parameter won: Whether the player won the game
    func finishGame(won: Bool) {
        NotificationCenter.default.post(name: .revealStats, object: nil)
        
        if won {
            gameState = .Won
            board.flagMines()
            mainButton.set(state: .Cool)
        } else {
            gameState = .Lost
            board.lostGame()
            mainButton.set(state: .Dead)
        }
        gameTimer.stopTimer()
    }
    
    /// Handles game reset logic for the board, stats, and number displays
    /// - Parameter restart: Whether the previous board is being replayed
    func newGame(restart: Bool = false) {
        gameState = .Unstarted
        NotificationCenter.default.post(name: .resetStats, object: nil)
        
        board.reset(restart: restart)
        gameTimer.reset()
        mineCounter.reset(mines: self.mines)
    }
    
    /// Called when the previous board should be replayed
    /// - Parameter notification: The notification triggering this callback
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
