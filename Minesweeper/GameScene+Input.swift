//
//  GameScene+Input.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/13/22.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    override func mouseDown(with event: NSEvent) {
        let clickedNode = self.nodes(at: event.location(in: scene!))
        if let name = clickedNode[0].name {
            if (name == "Main Button") {
                mainButton.texture = Resources.mainButton.happyPressed
            } else {
                if gameOver { return }
                mainButton.texture = Resources.mainButton.cautious
            }
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        let clickedNode = self.nodes(at: event.location(in: scene!))
        
        if let name = clickedNode[0].name {
            if (name == "Main Button") {
                mainButton.texture = Resources.mainButton.happy
                newGame()
            } else {
                if gameOver { return }
                if !gameStarted {
                    timerView.startTimer()
                    gameStarted = true
                }
                
                mainButton.texture = Resources.mainButton.happy
                let coords = Util.convertLocation(name: name)
                
                if board.tileAt(r: coords[0], c: coords[1])!.state == .Flagged {
                    counterView.increment()
                }
                
                if board.revealAt(r: coords[0], c: coords[1]) {
                    finishGame(won: false)
                }
                else if board.revealedTiles == rows*cols-mines {
                    finishGame(won: true)
                }
            }
        }
    }
    
    override func keyDown(with event: NSEvent) {
        
    }
    
    override func rightMouseDown(with event: NSEvent) {
        if gameOver == true { return }
        let clickedNode = self.nodes(at: event.location(in: scene!))
        
        if let name = clickedNode[0].name {
            let coords = Util.convertLocation(name: name)
            let tile = board.tileAt(r: coords[0], c: coords[1])
            
            if tile!.state == .Flagged {
                board.setAt(r: coords[0], c: coords[1], state: .Covered)
                counterView.increment()
            }
            else if tile!.state == .Covered || tile!.state == .Question {
                board.setAt(r: coords[0], c: coords[1], state: .Flagged)
                counterView.decrement()
            }
        }
    }
    
    override func rightMouseUp(with event: NSEvent) {}
    
    override func mouseDragged(with event: NSEvent) {
        
    }
    
}
