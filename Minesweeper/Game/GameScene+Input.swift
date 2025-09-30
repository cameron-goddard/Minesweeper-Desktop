//
//  GameScene+Input.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/13/22.
//

import Defaults
import GameplayKit
import SpriteKit

extension GameScene {

    override func mouseDown(with event: NSEvent) {
        let clickedNode = self.nodes(at: event.location(in: scene!))
        if let name = clickedNode[0].name {
            if name == "Main Button" {
                mainButton.set(state: .HappyPressed)
            } else {
                if gameState == .Won || gameState == .Lost { return }
                mainButton.set(state: .Cautious)

                currentTile = clickedNode[0].name

                let coords = convertLocation(name: name)
                let tile = board.tileAt(r: coords[0], c: coords[1])!

                if tile.state != .Uncovered {
                    tile.pressed()
                }
                if isMiddleClick() || event.modifierFlags.contains(.command) {
                    // TODO: Decrement right clicks by 1
                    isChord = true
                    board.adjacentPressAt(r: tile.r, c: tile.c)
                }
            }
        }
    }

    override func mouseUp(with event: NSEvent) {
        let clickedNode = self.nodes(at: event.location(in: scene!))

        if clickedNode.isEmpty {
            mainButton.set(state: .Happy)
            if isChord {
                // Raise tiles if we were chording and released outside a tile
                if let tileName = currentTile {
                    let coords = convertLocation(name: tileName)
                    board.adjacentRaiseAt(r: coords[0], c: coords[1])
                }
                isChord = false
            }
            return
        }

        if let name = clickedNode[0].name {
            if name == "Main Button" {
                mainButton.set(state: .Happy)
                newGame()
            } else {
                if gameState == .Won || gameState == .Lost { return }
                if gameState == .Unstarted {
                    gameTimer.start()
                    gameState = .InProgress
                }

                mainButton.set(state: .Happy)
                let coords = convertLocation(name: name)
                let tile = board.tileAt(r: coords[0], c: coords[1])!

                if tile.state == .Flagged {
                    mineCounter.increment()
                }

                if board.revealAt(r: coords[0], c: coords[1], isChord: isChord) {
                    finishGame(won: false)
                } else if board.revealedTiles == rows * cols - mines {
                    finishGame(won: true)
                }
                isChord = false
            }
        }
    }

    override func keyDown(with event: NSEvent) {

    }

    override func rightMouseDown(with event: NSEvent) {
        if gameState == .Won || gameState == .Lost { return }
        let clickedNode = self.nodes(at: event.location(in: scene!))

        if let name = clickedNode[0].name {
            if name == "Main Button" { return }

            let coords = convertLocation(name: name)
            let tile = board.tileAt(r: coords[0], c: coords[1])!

            if isMiddleClick() {
                isChord = true
                board.adjacentPressAt(r: tile.r, c: tile.c)
                return
            }

            if tile.state == .Flagged {
                if Defaults[.General.questions] {
                    board.setAt(r: coords[0], c: coords[1], state: .Question)
                } else {
                    board.setAt(r: coords[0], c: coords[1], state: .Covered)
                }
                mineCounter.increment()
            } else if tile.state == .Covered {
                board.setAt(r: coords[0], c: coords[1], state: .Flagged)
                mineCounter.decrement()
            } else if tile.state == .Question {
                board.setAt(r: coords[0], c: coords[1], state: .Covered)
            }

            NotificationCenter.default.post(name: .updateStat, object: nil, userInfo: ["Effective": 0])
            NotificationCenter.default.post(name: .updateStat, object: nil, userInfo: ["Right": 0])
        }
    }

    override func rightMouseUp(with event: NSEvent) {
        // If we were chording, we need to perform the chord action
        if isChord {
            let clickedNode = self.nodes(at: event.location(in: scene!))

            // If still over a tile, perform the chord
            if !clickedNode.isEmpty, let name = clickedNode[0].name, name != "Main Button" {
                if gameState == .Won || gameState == .Lost {
                    isChord = false
                    return
                }
                if gameState == .Unstarted {
                    gameTimer.start()
                    gameState = .InProgress
                }

                let coords = convertLocation(name: name)
                let tile = board.tileAt(r: coords[0], c: coords[1])!

                if board.revealAt(r: coords[0], c: coords[1], isChord: true) {
                    finishGame(won: false)
                } else if board.revealedTiles == rows * cols - mines {
                    finishGame(won: true)
                }
            } else if let tileName = currentTile {
                // If not over a tile, use the last known tile position
                let coords = convertLocation(name: tileName)
                board.adjacentRaiseAt(r: coords[0], c: coords[1])
            }

            isChord = false
            mainButton.set(state: .Happy)
        }
    }

    override func mouseDragged(with event: NSEvent) {
        let clickedNode = self.nodes(at: event.location(in: scene!))

        if clickedNode.count != 0, let name = clickedNode[0].name {
            if name == "Main Button" { return }
            if gameState == .Won || gameState == .Lost { return }

            if currentTile == clickedNode[0].name {
                let coords = convertLocation(name: name)
                let tile = board.tileAt(r: coords[0], c: coords[1])

                if tile?.state != .Uncovered {
                    tile?.pressed()
                }
                if isChord {
                    board.adjacentPressAt(r: tile!.r, c: tile!.c)
                }
            } else {
                let coords = convertLocation(name: currentTile!)
                let tile = board.tileAt(r: coords[0], c: coords[1])

                if isChord {
                    let coords = convertLocation(name: clickedNode[0].name!)
                    board.adjacentRaiseAt(r: tile!.r, c: tile!.c, diffR: coords[0], diffC: coords[1])
                } else {
                    tile?.raised()
                }
                currentTile = clickedNode[0].name
            }
        }
    }

    private func isMiddleClick() -> Bool {
        return (NSEvent.pressedMouseButtons & 0b11) == 0b11
    }

    private func convertLocation(name: String) -> [Int] {
        let coords = name.components(separatedBy: ",")
        let r = Int(String(coords[0]))!
        let c = Int(String(coords[1]))!
        return [r, c]
    }
}
