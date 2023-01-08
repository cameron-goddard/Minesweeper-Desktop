//
//  CustomGameViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 8/1/22.
//

import Cocoa

class CustomGameViewController: NSViewController {

    @IBOutlet weak var sizeWidthTextField: NSTextField!
    @IBOutlet weak var sizeHeightTextField: NSTextField!
    @IBOutlet weak var minesTextField: NSTextField!
    @IBOutlet weak var difficultyLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
    }
    
    @IBAction func randomButtonPressed(_ sender: Any) {
        sizeWidthTextField.integerValue = Int.random(in: 1..<100)
        sizeHeightTextField.integerValue = Int.random(in: 1..<100)
        minesTextField.integerValue = Int.random(in: 1..<50)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(self)
    }
    
    @IBAction func generateButtonPressed(_ sender: Any) {
        // TODO: validate inputs
        self.dismiss(self)
        NotificationCenter.default.post(name: Notification.Name("NewCustomGame"), object: [sizeWidthTextField.integerValue, sizeHeightTextField.integerValue, minesTextField.integerValue], userInfo: nil)
    }
}
