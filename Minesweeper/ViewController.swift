//
//  ViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import Cocoa
import SpriteKit
import GameplayKit
import Defaults

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    var difficulty = Defaults[.difficulty]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setSubtitle(notification:)), name: Notification.Name("SetSubtitle"), object: nil)
        
        if let view = self.skView {
            let rows, cols, mines: Int
            
            if difficulty != "Custom" {
                rows = Util.difficulties[difficulty]![0]
                cols = Util.difficulties[difficulty]![1]
                mines = Util.difficulties[difficulty]![2]
            } else {
                rows = Defaults[.customDifficulty][0]
                cols = Defaults[.customDifficulty][1]
                mines = Defaults[.customDifficulty][2]
            }
            
            // Consider changing fullSizeContentView in the future
            view.setFrameSize(NSSize(width: Util.scale*CGFloat(24+cols*16), height: Util.scale*CGFloat(67+rows*16)))
            
            Util.currentTheme = Util.theme(withName: Defaults[.theme])
            let scene = GameScene(size: self.skView.frame.size, rows: rows, cols: cols, mines: mines)
            view.presentScene(scene)
            
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
    }
    
    override func viewDidAppear() {
        if Defaults[.toolbarDifficulty] {
            view.window!.subtitle = difficulty
        }
    }
    
    @objc func setSubtitle(notification: Notification) {
        if Defaults[.toolbarDifficulty] {
            view.window!.subtitle = difficulty
        } else {
            view.window!.subtitle = ""
        }
    }
}
