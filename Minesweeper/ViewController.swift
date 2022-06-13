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
    var difficulty = "Beginner"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.skView {
            let rows = Util.difficulties[difficulty]![0]
            let cols = Util.difficulties[difficulty]![1]
            let mines = Util.difficulties[difficulty]![2]
            
            self.view.setFrameSize(NSSize(width: Util.scale*CGFloat(24+cols*16), height: Util.scale*CGFloat(67+rows*16)))
            Resources.initialize()
            let scene = GameScene(size: self.skView.frame.size, rows: rows, cols: cols, mines: mines)
            
            view.presentScene(scene)
            
            //view.showsFPS = true
            //view.showsNodeCount = true
        }
    }
}

