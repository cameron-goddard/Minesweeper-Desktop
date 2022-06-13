//
//  Timer.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/8/22.
//

import Cocoa
import SpriteKit

class TimerView: NumberView {
    
    var timer = Timer()
    var seconds = 0
    
    override init() {}
    
    func startTimer() {
        seconds = 0
        self.set(value: 0)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func reset() {
        timer.invalidate()
        self.set(value: 0)
    }
    
    @objc func fireTimer() {
        seconds += 1
        if seconds == 999 {
            timer.invalidate()
        }
        set(value: seconds)
    }
}
