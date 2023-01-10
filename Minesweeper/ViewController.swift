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
}
