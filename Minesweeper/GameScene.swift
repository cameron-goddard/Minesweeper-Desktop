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
    
//    private func makeNode(texture: SKTexture, ) {
//        
//    }
    
    func setNodes() {
        background = SKSpriteNode(texture: Util.currentTheme.borders.filler)
        background.anchorPoint = CGPoint(x: 0, y: 1)
        background.position = CGPoint(x: self.frame.minX, y: self.frame.maxY)
        background.xScale = self.frame.width
        background.yScale = 66 * scale
        self.addChild(background)
        
        topLeftCorner = SKSpriteNode(texture: Util.currentTheme.borders.cornerTopLeft)
        topLeftCorner.anchorPoint = CGPoint(x: 0, y: 1)
        topLeftCorner.setScale(scale)
        topLeftCorner.position = CGPoint(x: self.frame.minX, y: self.frame.maxY)
        topLeftCorner.zPosition = 2
        self.addChild(topLeftCorner)

        topRightCorner = SKSpriteNode(texture: Util.currentTheme.borders.cornerTopRight)
        topRightCorner.anchorPoint = CGPoint(x: 0, y: 1)
        topRightCorner.setScale(scale)
        topRightCorner.position = CGPoint(x: self.frame.maxX - topRightCorner.frame.width, y: self.frame.maxY)
        topRightCorner.zPosition = 2
        self.addChild(topRightCorner)

        topBorder = SKSpriteNode(texture: Util.currentTheme.borders.borderTop)
        topBorder.setScale(scale)
        topBorder.xScale = (self.frame.maxX - self.frame.minX)
        topBorder.anchorPoint = CGPoint(x: 0, y: 1)
        topBorder.position = CGPoint(x: CGFloat(self.frame.minX), y: self.frame.maxY)
        self.addChild(topBorder)
        
        mainButton = SKSpriteNode(texture: Util.currentTheme.mainButton.happy)
        mainButton.name = "Main Button"
        mainButton.setScale(scale)
        mainButton.position = CGPoint(x: -mainButton.frame.width/2, y: topBorder.position.y-topBorder.size.height-(scale*4))
        mainButton.anchorPoint = CGPoint(x: 0, y: 1)
        self.addChild(mainButton)
        
        middleBorder = SKSpriteNode(texture: Util.currentTheme.borders.borderMiddle)
        middleBorder.setScale(scale)
        middleBorder.xScale = (self.frame.maxX - self.frame.minX)
        middleBorder.anchorPoint = CGPoint(x: 0, y: 1)
        middleBorder.position = CGPoint(x: CGFloat(self.frame.minX), y: mainButton.position.y-mainButton.size.height-(scale*3))
        middleBorder.zPosition = 2
        self.addChild(middleBorder)

        bottomBorder = SKSpriteNode(texture: Util.currentTheme.borders.borderBottom)
        bottomBorder.setScale(scale)
        bottomBorder.xScale = (self.frame.maxX - self.frame.minX)
        bottomBorder.anchorPoint = CGPoint(x: 0, y: 1)
        bottomBorder.position = CGPoint(x: CGFloat(self.frame.minX), y: self.frame.minY + bottomBorder.frame.height)
        self.addChild(bottomBorder)

        middleLeftCorner = SKSpriteNode(texture: Util.currentTheme.borders.cornerMiddleLeft)
        middleLeftCorner.anchorPoint = CGPoint(x: 0, y: 1)
        middleLeftCorner.setScale(scale)
        middleLeftCorner.position = CGPoint(x: self.frame.minX, y: middleBorder.position.y)
        middleLeftCorner.zPosition = 3
        self.addChild(middleLeftCorner)
        
        middleRightCorner = SKSpriteNode(texture: Util.currentTheme.borders.cornerMiddleRight)
        middleRightCorner.anchorPoint = CGPoint(x: 0, y: 1)
        middleRightCorner.setScale(scale)
        middleRightCorner.position = CGPoint(x: self.frame.maxX - middleRightCorner.frame.width, y: middleBorder.position.y)
        middleRightCorner.zPosition = 3
        self.addChild(middleRightCorner)

        filler = SKSpriteNode(texture: Util.currentTheme.borders.filler)
        filler.anchorPoint = CGPoint(x: 1, y: 1)
        filler.setScale(scale)
        filler.position = CGPoint(x: middleRightCorner.position.x-middleRightCorner.size.width, y: middleBorder.position.y-middleBorder.size.height+2)
        filler.zPosition = 4
        self.addChild(filler)
        
        topLeftBorder = SKSpriteNode(texture: Util.currentTheme.borders.borderTopLeft)
        topLeftBorder.anchorPoint = CGPoint(x: 0, y: 1)
        topLeftBorder.setScale(scale)
        topLeftBorder.yScale = (self.frame.maxY - middleLeftCorner.position.y)
        topLeftBorder.position = CGPoint(x: self.frame.minX, y: self.frame.maxY)
        self.addChild(topLeftBorder)

        topRightBorder = SKSpriteNode(texture: Util.currentTheme.borders.borderTopRight)
        topRightBorder.anchorPoint = CGPoint(x: 0, y: 1)
        topRightBorder.setScale(scale)
        topRightBorder.yScale = (self.frame.maxY - middleRightCorner.position.y)
        topRightBorder.position = CGPoint(x: self.frame.maxX - topRightBorder.size.width, y: self.frame.maxY)
        self.addChild(topRightBorder)
        
        leftBorder = SKSpriteNode(texture: Util.currentTheme.borders.borderLeft)
        leftBorder.anchorPoint = CGPoint(x: 0, y: 1)
        leftBorder.setScale(scale)
        leftBorder.yScale = (middleLeftCorner.position.y - self.frame.minY)
        leftBorder.position = CGPoint(x: self.frame.minX, y: self.frame.maxY - topLeftBorder.size.height)
        self.addChild(leftBorder)

        rightBorder = SKSpriteNode(texture: Util.currentTheme.borders.borderRight)
        rightBorder.anchorPoint = CGPoint(x: 0, y: 1)
        rightBorder.setScale(scale)
        rightBorder.yScale = (middleRightCorner.position.y - self.frame.minY)
        rightBorder.position = CGPoint(x: self.frame.maxX - rightBorder.size.width, y: self.frame.maxY - topRightBorder.size.height)
        self.addChild(rightBorder)
        
        counterView.node.position = CGPoint(x: topLeftBorder.position.x+topLeftBorder.size.width+4*scale, y: mainButton.position.y)
        self.addChild(counterView.node)

        timerView.node.position = CGPoint(x: topRightBorder.position.x-45*scale, y: mainButton.position.y)
        self.addChild(timerView.node)
        
        self.addChild(board.node)
        
        bottomLeftCorner = SKSpriteNode(texture: Util.currentTheme.borders.cornerBottomLeft)
        bottomLeftCorner.anchorPoint = CGPoint(x: 0, y: 1)
        bottomLeftCorner.setScale(scale)
        bottomLeftCorner.position = CGPoint(x: self.frame.minX, y: bottomBorder.position.y)
        bottomLeftCorner.zPosition = 2
        self.addChild(bottomLeftCorner)

        bottomRightCorner = SKSpriteNode(texture: Util.currentTheme.borders.cornerBottomRight)
        bottomRightCorner.anchorPoint = CGPoint(x: 0, y: 1)
        bottomRightCorner.setScale(scale)
        bottomRightCorner.position = CGPoint(x: self.frame.maxX - bottomRightCorner.frame.width, y: bottomBorder.position.y)
        bottomRightCorner.zPosition = 2
        self.addChild(bottomRightCorner)
    }
    
    func setTextures() {
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
        
        board.setTextures()
        timerView.setTextures()
        counterView.setTextures()
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setNodes()
        setTextures()
    }
    
    func finishGame(won: Bool) {
        gameOver = true
        gameStarted = false
        NotificationCenter.default.post(name: Notification.Name("RevealStats"), object: nil)
        
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
        NotificationCenter.default.post(name: Notification.Name("ResetStats"), object: nil)
        
        board.reset()
        timerView.reset()
        counterView.reset(mines: self.mines)
    }
    
    @objc func restartGame(_ notification: Notification) {
        board.revealedTiles = 0
        gameOver = false
        gameStarted = false
        NotificationCenter.default.post(name: Notification.Name("ResetStats"), object: nil)
        
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
