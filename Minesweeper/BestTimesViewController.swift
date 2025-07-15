//
//  BestTimesViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 7/11/25.
//

import Cocoa
import Defaults

class BestTimesViewController: NSViewController {

    @IBOutlet weak var beginner1Field: NSTextField!
    @IBOutlet weak var beginner2Field: NSTextField!
    @IBOutlet weak var beginner3Field: NSTextField!
    
    @IBOutlet weak var intermediate1Field: NSTextField!
    @IBOutlet weak var intermediate2Field: NSTextField!
    @IBOutlet weak var intermediate3Field: NSTextField!
    
    @IBOutlet weak var hard1Field: NSTextField!
    @IBOutlet weak var hard2Field: NSTextField!
    @IBOutlet weak var hard3Field: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func okButtonPressed(_ sender: NSButton) {
        self.dismiss(self)
    }
    
    @IBAction func resetScoresButtonPressed(_ sender: NSButton) {
        Defaults[.BestTimes.beginner] = [-1, -1, -1]
        Defaults[.BestTimes.intermediate] = [-1, -1, -1]
        Defaults[.BestTimes.hard] = [-1, -1, -1]
    }
}
