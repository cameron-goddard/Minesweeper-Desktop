//
//  GeneralViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/19/22.
//

import Cocoa

class GeneralViewController: NSViewController {

    @IBOutlet weak var toolbarDifficultyCheckbox: NSButton!
    @IBOutlet weak var appearancePopUp: NSPopUpButton!
    @IBOutlet weak var stylePopUp: NSPopUpButton!
    @IBOutlet weak var safeFirstClickCheckbox: NSButton!
    @IBOutlet weak var useQuestionsCheckbox: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
        
        if Util.userDefault(withKey: .ToolbarDifficulty) as! Bool {
            toolbarDifficultyCheckbox.state = .on
        } else {
            toolbarDifficultyCheckbox.state = .off
        }
        
        if Util.userDefault(withKey: .SafeFirstClick) as! Bool {
            safeFirstClickCheckbox.state = .on
        } else {
            safeFirstClickCheckbox.state = .off
        }
        
        if Util.userDefault(withKey: .UseQuestions) as! Bool {
            useQuestionsCheckbox.state = .on
        } else {
            useQuestionsCheckbox.state = .off
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "General"
    }
    
    @IBAction func toolbarDifficultyCheckboxClicked(_ sender: NSButton) {
        Util.setUserDefault(forKey: .ToolbarDifficulty, sender: sender)
    }
    
    @IBAction func appearancePopUpChanged(_ sender: Any) {
    }
    
    @IBAction func stylePopUpChanged(_ sender: Any) {
    }
    
    @IBAction func safeFirstClickCheckboxClicked(_ sender: NSButton) {
        Util.setUserDefault(forKey: .SafeFirstClick, sender: sender)
    }
    
    @IBAction func useQuestionsCheckboxClicked(_ sender: NSButton) {
        Util.setUserDefault(forKey: .UseQuestions, sender: sender)
    }
}
