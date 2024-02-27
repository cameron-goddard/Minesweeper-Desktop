//
//  GameScene+Input.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/13/22.
//

import SpriteKit
import GameplayKit
import Defaults

extension GameScene {
    
    override func mouseDown(with event: NSEvent) {
        let clickedNode = self.nodes(at: event.location(in: scene!))
        if let name = clickedNode[0].name {
            if (name == "Main Button") {
                mainButton.texture = Util.currentTheme.mainButton.happyPressed
            } else {
                if gameOver { return }
                mainButton.texture = Util.currentTheme.mainButton.cautious
                
                currentTile = clickedNode[0].name
                
                let coords = convertLocation(name: name)
                let tile = board.tileAt(r: coords[0], c: coords[1])!
                if tile.state != .Uncovered {
                    tile.pressed()
                }
            }
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        let clickedNode = self.nodes(at: event.location(in: scene!))
        
        if let name = clickedNode[0].name {
            if (name == "Main Button") {
                mainButton.texture = Util.currentTheme.mainButton.happy
                newGame()
            } else {
                if gameOver { return }
                if !gameStarted {
                    timerView.startTimer()
                    gameStarted = true
                }
                
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: "test", userInfo: ["3BV": Int.random(in: 0...10)])
                
                mainButton.texture = Util.currentTheme.mainButton.happy
                let coords = convertLocation(name: name)
                let tile = board.tileAt(r: coords[0], c: coords[1])!
                
                
                if tile.state == .Flagged {
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
            let coords = convertLocation(name: name)
            let tile = board.tileAt(r: coords[0], c: coords[1])
            
            if tile!.state == .Flagged {
                if Defaults[.questions] {
                    board.setAt(r: coords[0], c: coords[1], state: .Question)
                } else {
                    board.setAt(r: coords[0], c: coords[1], state: .Covered)
                }
                counterView.increment()
            }
            else if tile!.state == .Covered {
                board.setAt(r: coords[0], c: coords[1], state: .Flagged)
                counterView.decrement()
            }
            else if tile!.state == .Question {
                board.setAt(r: coords[0], c: coords[1], state: .Covered)
            }
        }
    }
    
    override func rightMouseUp(with event: NSEvent) {}
    
    override func mouseDragged(with event: NSEvent) {
        let clickedNode = self.nodes(at: event.location(in: scene!))
        
        if clickedNode.count != 0, let name = clickedNode[0].name {
            if name == "Main Button" { return }
            if gameOver { return }
            
            if currentTile == clickedNode[0].name {
                let coords = convertLocation(name: name)
                let tile = board.tileAt(r: coords[0], c: coords[1])
                
                if tile?.state != .Uncovered {
                    tile?.pressed()
                }
            } else {
                let coords = convertLocation(name: currentTile!)
                let tile = board.tileAt(r: coords[0], c: coords[1])
                
                tile?.setState(state: tile!.state)
                currentTile = clickedNode[0].name
            }
        }
    }
    
    override func mouseExited(with event: NSEvent) {
        let clickedNode = self.nodes(at: event.location(in: scene!))
        if let name = clickedNode[0].name {
            let coords = convertLocation(name: name)
            let tile = board.tileAt(r: coords[0], c: coords[1])
            if tile?.state != .Uncovered {
                tile?.raised()
            }
        }
    }
    
    func convertLocation(name: String) -> Array<Int> {
        let coords = name.components(separatedBy: ",")
        let r = Int(String(coords[0]))!
        let c = Int(String(coords[1]))!
        return [r, c]
    }
    
}
