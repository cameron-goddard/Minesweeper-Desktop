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
    
    var difficulty = "Beginner"
    
    var rows : Int
    var cols : Int
    var mines : Int
    
    var topBorder: SKSpriteNode!
    var topLeftCorner: SKSpriteNode!
    var topRightCorner: SKSpriteNode!
    var leftBorder: SKSpriteNode!
    var rightBorder: SKSpriteNode!
    var bottomBorder: SKSpriteNode!
    var middleBorder: SKSpriteNode!
    var middleLeftCorner: SKSpriteNode!
    var middleRightCorner: SKSpriteNode!
    var topLeftBorder: SKSpriteNode!
    var topRightBorder: SKSpriteNode!
    var bottomLeftCorner: SKSpriteNode!
    var bottomRightCorner: SKSpriteNode!

    var filler: SKSpriteNode!
    
    init(size: CGSize, rows: Int, cols: Int, mines: Int) {
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
    
    func setUp() {
        topLeftCorner = SKSpriteNode(imageNamed: "corner_topleft")
        topLeftCorner.texture?.filteringMode = .nearest
        topLeftCorner.anchorPoint = CGPoint(x: 0, y: 1)
        topLeftCorner.setScale(scale)
        topLeftCorner.position = CGPoint(x: self.frame.minX, y: self.frame.maxY)
        topLeftCorner.zPosition = 3
        self.addChild(topLeftCorner)

        topRightCorner = SKSpriteNode(imageNamed: "corner_topright")
        topRightCorner.texture?.filteringMode = .nearest
        topRightCorner.anchorPoint = CGPoint(x: 1, y: 1)
        topRightCorner.setScale(scale)
        topRightCorner.position = CGPoint(x: self.frame.maxX, y: self.frame.maxY)
        topRightCorner.zPosition = 3
        self.addChild(topRightCorner)

        for i in stride(from: self.frame.minX, to: self.frame.maxX, by: +1 as CGFloat) {
            topBorder = SKSpriteNode(imageNamed: "border_top")
            topBorder.texture?.filteringMode = .nearest
            topBorder.setScale(scale)
            topBorder.anchorPoint = CGPoint(x: 0.5, y: 1)
            topBorder.position = CGPoint(x: CGFloat(Float(i)), y: self.frame.maxY)
            topBorder.zPosition = 2
            self.addChild(topBorder)
        }
        
        mainButton = SKSpriteNode(texture: Resources.mainButton.happy)
        mainButton.name = "Main Button"
        mainButton.texture?.filteringMode = .nearest
        mainButton.setScale(scale)
        mainButton.position = CGPoint(x: 0, y: topBorder.position.y-topBorder.size.height-8)
        mainButton.anchorPoint = CGPoint(x: 0.5, y: 1)
        self.addChild(mainButton)
        
        for i in stride(from: self.frame.minX, to: self.frame.maxX, by: +1 as CGFloat) {
            middleBorder = SKSpriteNode(imageNamed: "border_middle")
            middleBorder.texture?.filteringMode = .nearest
            middleBorder.setScale(scale)
            middleBorder.anchorPoint = CGPoint(x: 0.5, y: 1)
            middleBorder.position = CGPoint(x: CGFloat(Float(i)), y: mainButton.position.y-mainButton.size.height-6)
            middleBorder.zPosition = 3
            self.addChild(middleBorder)

            bottomBorder = SKSpriteNode(imageNamed: "border_bottom")
            bottomBorder.texture?.filteringMode = .nearest
            bottomBorder.setScale(scale)
            bottomBorder.anchorPoint = CGPoint(x: 0.5, y: 0)
            bottomBorder.position = CGPoint(x: CGFloat(Float(i)), y: self.frame.minY)
            self.addChild(bottomBorder)
        }

        middleLeftCorner = SKSpriteNode(imageNamed: "corner_middleleft")
        middleLeftCorner.texture?.filteringMode = .nearest
        middleLeftCorner.anchorPoint = CGPoint(x: 0, y: 1)
        middleLeftCorner.setScale(scale)
        middleLeftCorner.position = CGPoint(x: self.frame.minX, y: middleBorder.position.y)
        middleLeftCorner.zPosition = 4
        self.addChild(middleLeftCorner)
        
        middleRightCorner = SKSpriteNode(imageNamed: "corner_middleright")
        middleRightCorner.texture?.filteringMode = .nearest
        middleRightCorner.anchorPoint = CGPoint(x: 1, y: 1)
        middleRightCorner.setScale(scale)
        middleRightCorner.position = CGPoint(x: self.frame.maxX, y: middleBorder.position.y)
        middleRightCorner.zPosition = 4
        self.addChild(middleRightCorner)

        filler = SKSpriteNode(imageNamed: "filler")
        filler.texture?.filteringMode = .nearest
        filler.anchorPoint = CGPoint(x: 1, y: 1)
        filler.setScale(scale)
        filler.position = CGPoint(x: middleRightCorner.position.x-middleRightCorner.size.width, y: middleBorder.position.y-middleBorder.size.height+2)
        filler.zPosition = 4
        self.addChild(filler)
        
        for i in stride(from: self.frame.minY, to: self.frame.maxY, by: +1 as CGFloat) {
            if (i > middleLeftCorner.position.y) {
                topLeftBorder = SKSpriteNode(imageNamed: "border_topleft")
                topLeftBorder.texture?.filteringMode = .nearest
                topLeftBorder.anchorPoint = CGPoint(x: 0, y: 1)
                topLeftBorder.setScale(scale)
                topLeftBorder.position = CGPoint(x: self.frame.minX, y: i)
                self.addChild(topLeftBorder)

                topRightBorder = SKSpriteNode(imageNamed: "border_topright")
                topRightBorder.texture?.filteringMode = .nearest
                topRightBorder.anchorPoint = CGPoint(x: 1, y: 1)
                topRightBorder.setScale(scale)
                topRightBorder.position = CGPoint(x: self.frame.maxX, y: i)
                self.addChild(topRightBorder)
            } else {
                leftBorder = SKSpriteNode(imageNamed: "border_left")
                leftBorder.anchorPoint = CGPoint(x: 0, y: 1)
                leftBorder.texture?.filteringMode = .nearest
                leftBorder.setScale(scale)
                leftBorder.position = CGPoint(x: self.frame.minX, y: i)
                self.addChild(leftBorder)

                rightBorder = SKSpriteNode(imageNamed: "border_right")
                rightBorder.anchorPoint = CGPoint(x: 1, y: 1)
                rightBorder.texture?.filteringMode = .nearest
                rightBorder.setScale(scale)
                rightBorder.position = CGPoint(x: self.frame.maxX, y: i)
                self.addChild(rightBorder)
            }
        }
        
        counterView.node.position = CGPoint(x: topLeftBorder.position.x+topLeftBorder.size.width+6*scale, y: mainButton.position.y-scale)
        self.addChild(counterView.node)

        timerView.node.position = CGPoint(x: topRightBorder.position.x-topRightBorder.size.width-45*scale, y: mainButton.position.y-scale)
        self.addChild(timerView.node)
        
        //board.node.position = CGPoint(x: board.node.position.x, y: middleBorder.position.y-150)
        self.addChild(board.node)
        
        bottomLeftCorner = SKSpriteNode(imageNamed: "corner_bottomleft")
        bottomLeftCorner.texture?.filteringMode = .nearest
        bottomLeftCorner.anchorPoint = CGPoint(x: 0, y: 0)
        bottomLeftCorner.setScale(scale)
        bottomLeftCorner.position = CGPoint(x: self.frame.minX, y: bottomBorder.position.y)
        bottomLeftCorner.zPosition = 3
        self.addChild(bottomLeftCorner)

        bottomRightCorner = SKSpriteNode(imageNamed: "corner_bottomright")
        bottomRightCorner.texture?.filteringMode = .nearest
        bottomRightCorner.anchorPoint = CGPoint(x: 1, y: 0)
        bottomRightCorner.setScale(scale)
        bottomRightCorner.position = CGPoint(x: self.frame.maxX, y: bottomBorder.position.y)
        bottomRightCorner.zPosition = 3
        self.addChild(bottomRightCorner)
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = NSColor(red: 61, green: 61, blue: 61, alpha: 1)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setUp()
    }
    
    func finishGame(won: Bool) {
        gameOver = true
        gameStarted = false
        if won {
            board.flagMines()
            mainButton.texture = Resources.mainButton.cool
        } else {
            board.lostGame()
            mainButton.texture = Resources.mainButton.dead
        }
        timerView.stopTimer()
    }
    
    func newGame() {
        board.revealedTiles = 0
        gameOver = false
        gameStarted = false
        board.reset() //change later to account for different sizes
        timerView.reset()
        counterView.reset(mines: self.mines)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
