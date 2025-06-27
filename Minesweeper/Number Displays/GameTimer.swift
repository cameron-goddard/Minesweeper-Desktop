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
    var elapsedTime: TimeInterval = 0
    
    weak var delegate: GameTimerDelegate?
    
    override init(sceneSize: CGSize, scale: CGFloat) {
        super.init(sceneSize: sceneSize, scale: scale)
        self.position = CGPoint(x: sceneSize.width/2 - 57 * scale, y: sceneSize.height/2 - (scale * 15))
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
        self.set(value: 0)
        
        delegate?.updateTime(0)
    }
    
    @objc func fireTimer() {
        guard let startTime = self.startTime else { return }
        elapsedTime = Date().timeIntervalSince(startTime)
        self.set(value: Int(elapsedTime))
        
        delegate?.updateTime(elapsedTime)
    }
    
    /// Force update all textures. Called when a theme is changed
    /// - Parameter theme: The theme to update to
    override func updateTextures(to theme: Theme) {
        super.updateTextures(to: theme)
        self.set(value: Int(elapsedTime), theme: theme)
    }
    
    /// Force update the size of all nodes. Called when the scale setting is changed, or the Zoom button is pressed
    /// - Parameters:
    ///   - sceneSize: The size of the parent scene. Needed for positioning
    ///   - scale: The scale to update to
    override func updateScale(sceneSize: CGSize, scale: CGFloat) {
        super.updateScale(sceneSize: sceneSize, scale: scale)
        self.position = CGPoint(x: sceneSize.width/2 - 57 * scale, y: sceneSize.height/2 - (scale * 15))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol GameTimerDelegate: AnyObject {
    func updateTime(_ time: TimeInterval)
}
