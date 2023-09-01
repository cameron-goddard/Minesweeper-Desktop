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
    var theme: Theme
    
    var board: Board!
    var mainButton: SKSpriteNode!
    var timerView: TimerView!
    var counterView: CounterView!
    var gameOver = false
    var gameStarted = false
    
    var difficulty = "Intermediate"
    
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
    
    var currentTile: String? = nil
    
    init(size: CGSize, theme: Theme, rows: Int, cols: Int, mines: Int) {
        self.theme = theme
        self.rows = rows
        self.cols = cols
        self.mines = mines
        board = Board(rows: rows, cols: cols, mines: mines)
        timerView = TimerView()
        counterView = CounterView(mines: self.mines)
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNodes() {
        topLeftCorner = SKSpriteNode(texture: theme.borders.cornerTopLeft)
        topLeftCorner.anchorPoint = CGPoint(x: 0, y: 1)
        topLeftCorner.setScale(scale)
        topLeftCorner.position = CGPoint(x: self.frame.minX, y: self.frame.maxY)
        topLeftCorner.zPosition = 2
        self.addChild(topLeftCorner)

        topRightCorner = SKSpriteNode(texture: theme.borders.cornerTopRight)
        topRightCorner.anchorPoint = CGPoint(x: 1, y: 1)
        topRightCorner.setScale(scale)
        topRightCorner.position = CGPoint(x: self.frame.maxX, y: self.frame.maxY)
        topRightCorner.zPosition = 2
        self.addChild(topRightCorner)

        topBorder = SKSpriteNode(texture: theme.borders.borderTop)
        topBorder.setScale(scale)
        topBorder.xScale = (self.frame.maxX - self.frame.minX)
        topBorder.anchorPoint = CGPoint(x: 0, y: 1)
        topBorder.position = CGPoint(x: CGFloat(self.frame.minX), y: self.frame.maxY)
        self.addChild(topBorder)
        
        mainButton = SKSpriteNode(texture: theme.mainButton.happy)
        mainButton.name = "Main Button"
        mainButton.setScale(scale)
        mainButton.position = CGPoint(x: 0, y: topBorder.position.y-topBorder.size.height-(scale*4))
        mainButton.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.addChild(mainButton)
        
        middleBorder = SKSpriteNode(texture: theme.borders.borderMiddle)
        middleBorder.setScale(scale)
        middleBorder.xScale = (self.frame.maxX - self.frame.minX)
        middleBorder.anchorPoint = CGPoint(x: 0, y: 1)
        middleBorder.position = CGPoint(x: CGFloat(self.frame.minX), y: mainButton.position.y-mainButton.size.height-(scale*3))
        middleBorder.zPosition = 2
        self.addChild(middleBorder)

        bottomBorder = SKSpriteNode(texture: theme.borders.borderBottom)
        bottomBorder.setScale(scale)
        bottomBorder.xScale = (self.frame.maxX - self.frame.minX)
        bottomBorder.anchorPoint = CGPoint(x: 0, y: 0)
        bottomBorder.position = CGPoint(x: CGFloat(self.frame.minX), y: self.frame.minY)
        self.addChild(bottomBorder)

        middleLeftCorner = SKSpriteNode(texture: theme.borders.cornerMiddleLeft)
        middleLeftCorner.anchorPoint = CGPoint(x: 0, y: 1)
        middleLeftCorner.setScale(scale)
        middleLeftCorner.position = CGPoint(x: self.frame.minX, y: middleBorder.position.y)
        middleLeftCorner.zPosition = 3
        self.addChild(middleLeftCorner)
        
        middleRightCorner = SKSpriteNode(texture: theme.borders.cornerMiddleRight)
        middleRightCorner.anchorPoint = CGPoint(x: 1, y: 1)
        middleRightCorner.setScale(scale)
        middleRightCorner.position = CGPoint(x: self.frame.maxX, y: middleBorder.position.y)
        middleRightCorner.zPosition = 3
        self.addChild(middleRightCorner)

        filler = SKSpriteNode(imageNamed: "filler")
        filler.texture?.filteringMode = .nearest
        filler.anchorPoint = CGPoint(x: 1, y: 1)
        filler.setScale(scale)
        filler.position = CGPoint(x: middleRightCorner.position.x-middleRightCorner.size.width, y: middleBorder.position.y-middleBorder.size.height+2)
        filler.zPosition = 4
        self.addChild(filler)
        
        topLeftBorder = SKSpriteNode(texture: theme.borders.borderTopLeft)
        topLeftBorder.anchorPoint = CGPoint(x: 0, y: 1)
        topLeftBorder.setScale(scale)
        topLeftBorder.yScale = (self.frame.maxY - middleLeftCorner.position.y)
        topLeftBorder.position = CGPoint(x: self.frame.minX, y: self.frame.maxY)
        self.addChild(topLeftBorder)

        topRightBorder = SKSpriteNode(texture: theme.borders.borderTopRight)
        topRightBorder.anchorPoint = CGPoint(x: 1, y: 1)
        topRightBorder.setScale(scale)
        topRightBorder.yScale = (self.frame.maxY - middleRightCorner.position.y)
        topRightBorder.position = CGPoint(x: self.frame.maxX, y: self.frame.maxY)
        self.addChild(topRightBorder)
        
        leftBorder = SKSpriteNode(texture: theme.borders.borderLeft)
        leftBorder.anchorPoint = CGPoint(x: 0, y: 1)
        leftBorder.setScale(scale)
        leftBorder.yScale = (middleLeftCorner.position.y - self.frame.minY)
        leftBorder.position = CGPoint(x: self.frame.minX, y: self.frame.maxY - topLeftBorder.size.height)
        self.addChild(leftBorder)

        rightBorder = SKSpriteNode(texture: theme.borders.borderRight)
        rightBorder.anchorPoint = CGPoint(x: 1, y: 1)
        rightBorder.setScale(scale)
        rightBorder.yScale = (middleRightCorner.position.y - self.frame.minY)
        rightBorder.position = CGPoint(x: self.frame.maxX, y: self.frame.maxY - topRightBorder.size.height)
        self.addChild(rightBorder)
        
        counterView.node.position = CGPoint(x: topLeftBorder.position.x+topLeftBorder.size.width+6*scale, y: mainButton.position.y-scale)
        self.addChild(counterView.node)

        timerView.node.position = CGPoint(x: topRightBorder.position.x-topRightBorder.size.width-45*scale, y: mainButton.position.y-scale)
        self.addChild(timerView.node)
        
        //board.node.position = CGPoint(x: board.node.position.x, y: middleBorder.position.y-150)
        self.addChild(board.node)
        
        bottomLeftCorner = SKSpriteNode(texture: theme.borders.cornerBottomLeft)
        bottomLeftCorner.anchorPoint = CGPoint(x: 0, y: 0)
        bottomLeftCorner.setScale(scale)
        bottomLeftCorner.position = CGPoint(x: self.frame.minX, y: bottomBorder.position.y)
        bottomLeftCorner.zPosition = 2
        self.addChild(bottomLeftCorner)

        bottomRightCorner = SKSpriteNode(texture: theme.borders.cornerBottomRight)
        bottomRightCorner.anchorPoint = CGPoint(x: 1, y: 0)
        bottomRightCorner.setScale(scale)
        bottomRightCorner.position = CGPoint(x: self.frame.maxX, y: bottomBorder.position.y)
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
        
        board.setTextures()
        timerView.setTextures()
        counterView.setTextures()
        
        self.backgroundColor = Util.currentTheme.backgroundColor
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setNodes()
        setTextures()
    }
    
    func finishGame(won: Bool) {
        gameOver = true
        gameStarted = false
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
        board.reset()
        timerView.reset()
        counterView.reset(mines: self.mines)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
