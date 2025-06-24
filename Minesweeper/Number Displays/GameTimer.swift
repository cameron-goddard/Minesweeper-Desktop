//
//  GameTimer.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/8/22.
//

import Cocoa
import SpriteKit

class GameTimer: NumberDisplay {
    
    var gameTimer = Timer()
    var startTime: Date?
    
    override init(scale: CGFloat) {
        super.init(scale: scale)
    }
    
    func startTimer() {
        startTime = Date()
        gameTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(gameTimer, forMode: .common)
        self.set(value: 0)
    }
    
    func stopTimer() {
        gameTimer.invalidate()
    }
    
    func reset() {
        gameTimer.invalidate()
        NotificationCenter.default.post(name: .updateTime, object: TimeInterval())
        self.set(value: 0)
    }
    
    @objc func fireTimer() {
        guard let startTime = self.startTime else { return }
        let elapsedTime = Date().timeIntervalSince(startTime)
        
        NotificationCenter.default.post(name: .updateTime, object: elapsedTime)
        self.set(value: Int(elapsedTime))
    }
    
    /// Force update all textures. Called when a theme is changed
    override func updateTextures() {
        super.updateTextures()
        if !gameTimer.isValid {
            self.set(value: 0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
