//
//  BindingsViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/19/22.
//

import Cocoa

class BindingsViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "Key Bindings"
    }
    
}
