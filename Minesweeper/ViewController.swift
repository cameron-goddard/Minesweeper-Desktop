//
//  ViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    var difficulty = Util.userDefault(withKey: .CurrentDifficulty) as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.skView {
            let rows = Util.difficulties[difficulty]![0]
            let cols = Util.difficulties[difficulty]![1]
            let mines = Util.difficulties[difficulty]![2]
            
            //consider changing fullSizeContentView in the future
            view.setFrameSize(NSSize(width: Util.scale*CGFloat(24+cols*16), height: Util.scale*CGFloat(67+rows*16)))
            let scene = GameScene(size: self.skView.frame.size, theme: Util.currentTheme, rows: rows, cols: cols, mines: mines)
            view.presentScene(scene)
            
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
    }
    
    override func viewDidAppear() {
        if Util.userDefault(withKey: .ToolbarDifficulty) as! Bool {
            view.window!.subtitle = difficulty
        }
    }
    
    @objc func newGame(_ sender: NSMenuItem) {
        let rows = 16
        let cols = 30
        let mines = Util.difficulties[difficulty]![2]
        
        let newContentSize = NSSize(width: Util.scale*CGFloat(24+cols*16), height: Util.scale*CGFloat(67+rows*16))
        
        let newWindowFrameSize = view.window!.frameRect(forContentRect: NSRect(origin: .zero, size: newContentSize)).size
        
        let newWindowFrame = NSRect(
            origin: NSPoint(
                x: (view.window?.frame.origin.x)!,
                y: (view.window?.frame.origin.y)!
            ),
            size: newWindowFrameSize
        )
        
        if let view = self.skView {
            view.setFrameSize(newContentSize)
            view.window?.preservesContentDuringLiveResize = false
            view.window!.setFrame(newWindowFrame, display: false, animate: true)
            let scene = GameScene(size: newContentSize, theme: Util.currentTheme, rows: rows, cols: cols, mines: mines)
            view.presentScene(scene)
        }
    }
}

extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        view.subviews.forEach {$0.isHidden = false}
        view.layer!.contents = nil
    }
}
