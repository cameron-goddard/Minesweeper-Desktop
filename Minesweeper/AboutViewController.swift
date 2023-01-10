//
//  AboutViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 1/10/23.
//

import Cocoa

class AboutViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override public func mouseDown(with event: NSEvent) {
        self.view.window?.performDrag(with: event)
    }
    
    @IBAction func changelogButtonPressed(_ sender: NSButton) {
        let url = URL(string: "https://www.camerongoddard.com/ms-desktop/release_notes.html")!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func supportButtonPressed(_ sender: NSButton) {
    }
}
