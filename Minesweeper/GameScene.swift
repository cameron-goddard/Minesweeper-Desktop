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
    var mainButton: SKSpriteNode!
    var timerView: TimerView!
    var counterView: CounterView!
    var gameOver = false
    var gameStarted = false
    
    var rows, cols, mines : Int
    
    var topBorder,
        topLeftCorner,
        topRightCorner,
        leftBorder,
        rightBorder,
        bottomBorder,
        middleBorder,
        middleLeftCorner,
        middleRightCorner,
        topLeftBorder,
        topRightBorder,
        bottomLeftCorner,
        bottomRightCorner: SKSpriteNode!

    var filler: SKSpriteNode!
    var background: SKSpriteNode!
    
    var currentTile: String? = nil
    
    init(size: CGSize, rows: Int, cols: Int, mines: Int, minesLayout: [(Int, Int)]?) {
        self.rows = rows
        self.cols = cols
        self.mines = mines
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
        
        topLeftCorner = makeNode(
            texture: Util.currentTheme.borders.cornerTopLeft,
            position: CGPoint(x: self.frame.minX, y: self.frame.maxY),
            zPosition: 2
        )
        self.addChild(topLeftCorner)

        topRightCorner = makeNode(
            texture: Util.currentTheme.borders.cornerTopRight,
            position: CGPoint(
                x: self.frame.maxX - Util.currentTheme.borders.cornerTopRight.size().width * scale,
                y: self.frame.maxY),
            zPosition: 2
        )
        self.addChild(topRightCorner)

        topBorder = makeNode(
            texture: Util.currentTheme.borders.borderTop,
            position: CGPoint(x: CGFloat(self.frame.minX), y: self.frame.maxY)
        )
        topBorder.xScale = (self.frame.maxX - self.frame.minX)
        self.addChild(topBorder)
        
        mainButton = makeNode(
            texture: Util.currentTheme.mainButton.happy,
            position: CGPoint(
                x: -Util.currentTheme.mainButton.happy.size().width/2 * scale,
                y: topBorder.position.y-topBorder.size.height-(scale*4))
        )
        mainButton.name = "Main Button"
        self.addChild(mainButton)
        
        middleBorder = makeNode(
            texture: Util.currentTheme.borders.borderMiddle,
            position: CGPoint(
                x: CGFloat(self.frame.minX),
                y: mainButton.position.y-mainButton.size.height-(scale * 3)),
            zPosition: 2
        )
        middleBorder.xScale = (self.frame.maxX - self.frame.minX)
        self.addChild(middleBorder)

        bottomBorder = makeNode(
            texture: Util.currentTheme.borders.borderBottom,
            position: CGPoint(
                x: CGFloat(self.frame.minX),
                y: self.frame.minY + Util.currentTheme.borders.borderBottom.size().height * scale)
        )
        bottomBorder.xScale = (self.frame.maxX - self.frame.minX)
        self.addChild(bottomBorder)

        middleLeftCorner = makeNode(
            texture: Util.currentTheme.borders.cornerMiddleLeft,
            position: CGPoint(x: self.frame.minX, y: middleBorder.position.y),
            zPosition: 3
        )
        self.addChild(middleLeftCorner)
        
        middleRightCorner = makeNode(
            texture: Util.currentTheme.borders.cornerMiddleRight,
            position: CGPoint(
                x: self.frame.maxX - Util.currentTheme.borders.cornerMiddleRight.size().width * scale,
                y: middleBorder.position.y),
            zPosition: 3
        )
        self.addChild(middleRightCorner)

        // TODO
        filler = SKSpriteNode(texture: Util.currentTheme.borders.filler)
        filler.anchorPoint = CGPoint(x: 1, y: 1)
        filler.setScale(scale)
        filler.position = CGPoint(x: middleRightCorner.position.x-middleRightCorner.size.width, y: middleBorder.position.y-middleBorder.size.height+2)
//        filler.zPosition = 4
        self.addChild(filler)
        
        topLeftBorder = makeNode(
            texture: Util.currentTheme.borders.borderTopLeft,
            position: CGPoint(x: self.frame.minX, y: self.frame.maxY)
        )
        topLeftBorder.yScale = (self.frame.maxY - middleLeftCorner.position.y)
        self.addChild(topLeftBorder)

        topRightBorder = makeNode(
            texture: Util.currentTheme.borders.borderTopRight,
            position: CGPoint(
                x: self.frame.maxX - Util.currentTheme.borders.borderTopRight.size().width * scale,
                y: self.frame.maxY
            )
        )
        topRightBorder.yScale = (self.frame.maxY - middleRightCorner.position.y)
        self.addChild(topRightBorder)
        
        leftBorder = makeNode(
            texture: Util.currentTheme.borders.borderLeft,
            position: CGPoint(x: self.frame.minX, y: self.frame.maxY - topLeftBorder.size.height)
        )
        leftBorder.yScale = (middleLeftCorner.position.y - self.frame.minY)
        self.addChild(leftBorder)

        rightBorder = makeNode(
            texture: Util.currentTheme.borders.borderRight,
            position: CGPoint(
                x: self.frame.maxX - Util.currentTheme.borders.borderRight.size().width * scale,
                y: self.frame.maxY - topRightBorder.size.height
            )
        )
        rightBorder.yScale = (middleRightCorner.position.y - self.frame.minY)
        self.addChild(rightBorder)
        
        counterView.node.position = CGPoint(x: topLeftBorder.position.x+topLeftBorder.size.width+4*scale, y: mainButton.position.y)
        self.addChild(counterView.node)

        timerView.node.position = CGPoint(x: topRightBorder.position.x-45*scale, y: mainButton.position.y)
        self.addChild(timerView.node)
        
        self.addChild(board.node)
        
        bottomLeftCorner = makeNode(
            texture: Util.currentTheme.borders.cornerBottomLeft,
            position: CGPoint(x: self.frame.minX, y: bottomBorder.position.y)
        )
        self.addChild(bottomLeftCorner)

        bottomRightCorner = makeNode(
            texture: Util.currentTheme.borders.cornerBottomRight,
            position: CGPoint(
                x: self.frame.maxX - Util.currentTheme.borders.cornerBottomRight.size().width * scale,
                y: bottomBorder.position.y
            )
        )
        self.addChild(bottomRightCorner)
    }
    
    func updateTextures() {
        topLeftCorner.texture = Util.currentTheme.borders.cornerTopLeft
        topRightCorner.texture = Util.currentTheme.borders.cornerTopRight
        topBorder.texture = Util.currentTheme.borders.borderTop
        mainButton.texture = Util.currentTheme.mainButton.happy
        middleBorder.texture = Util.currentTheme.borders.borderMiddle
        bottomBorder.texture = Util.currentTheme.borders.borderBottom
        middleLeftCorner.texture = Util.currentTheme.borders.cornerMiddleLeft
        middleRightCorner.texture = Util.currentTheme.borders.cornerMiddleRight
        topLeftBorder.texture = Util.currentTheme.borders.borderTopLeft
        topRightBorder.texture = Util.currentTheme.borders.borderTopRight
        leftBorder.texture = Util.currentTheme.borders.borderLeft
        rightBorder.texture = Util.currentTheme.borders.borderRight
        bottomLeftCorner.texture = Util.currentTheme.borders.cornerBottomLeft
        bottomRightCorner.texture = Util.currentTheme.borders.cornerBottomRight
        filler.texture = Util.currentTheme.borders.filler
        background.texture = Util.currentTheme.borders.filler
        
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
