//
//  Timer.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/8/22.
//

import Cocoa
import SpriteKit

class TimerView: NumberView {
    
    var gameTimer = Timer()
    var startTime: Date?
    
    override init() {}
    
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
        NotificationCenter.default.post(name: Notification.Name("UpdateTime"), object: TimeInterval())
        self.set(value: 0)
    }
    
    @objc func fireTimer() {
        guard let startTime = self.startTime else { return }
        let elapsedTime = Date().timeIntervalSince(startTime)
        
        NotificationCenter.default.post(name: Notification.Name("UpdateTime"), object: elapsedTime)
        self.set(value: Int(elapsedTime))
    }
    
    override func setTextures() {
        super.setTextures()
        if !gameTimer.isValid {
            self.set(value: 0)
        }
    }
}
