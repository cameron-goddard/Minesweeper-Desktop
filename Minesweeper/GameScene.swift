//
//  GameScene.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var scale = Util.scale
    
    var board: Board!
    var borders: Borders!
    var timerView: TimerView!
    var counterView: CounterView!
    
    var mainButton: SKSpriteNode!
    var background: SKSpriteNode!
    
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Factory method for creating nodes for the game border
    /// - Parameters:
    ///   - texture: The current theme's texture for this node
    ///   - position: A specified 2D position for this node
    ///   - zPosition: The node's optional Z position
    /// - Returns: A properly scaled SKSpriteNode with the given texture and position
    private func makeNode(texture: SKTexture, position: CGPoint, zPosition: CGFloat = 0) -> SKSpriteNode {
        let node = SKSpriteNode(texture: texture)
        node.anchorPoint = CGPoint(x: 0, y: 1)
        node.position = position
        node.setScale(scale)
        if zPosition != 0 {
            node.zPosition = zPosition
        }
        
        return node
    }
    
    /// Creates the game board, counters, and borders with the current theme. Adds all to this game scene
    func addNodes() {
        background = makeNode(
            texture: Util.currentTheme.borders.filler,
            position: CGPoint(x: self.frame.minX, y: self.frame.maxY)
        )
        background.xScale = self.frame.width
        background.yScale = 66 * scale
        self.addChild(background)
        
        mainButton = makeNode(
            texture: Util.currentTheme.mainButton.happy,
            position: CGPoint(
                x: -Util.currentTheme.mainButton.happy.size().width/2 * scale,
                y: self.frame.maxY-(scale * 15))
        )
        mainButton.name = "Main Button"
        
        
        counterView.node.position = CGPoint(x: self.frame.minX + 16 * scale, y: mainButton.position.y)
        
        timerView.node.position = CGPoint(x: self.frame.maxX - 57 * scale, y: mainButton.position.y)
        
        self.addChild(mainButton)
        self.addChild(counterView.node)
        self.addChild(timerView.node)
        self.addChild(borders)
        self.addChild(board.node)
    }
    
    func updateTextures() {
        background.texture = Util.currentTheme.borders.filler
        
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
}

extension Notification.Name {
    static let restartGame = Notification.Name("RestartGame")
}
