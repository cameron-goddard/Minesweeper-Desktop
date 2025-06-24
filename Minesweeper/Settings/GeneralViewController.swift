//
//  GeneralViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/19/22.
//

import Cocoa
import Defaults

class GeneralViewController: NSViewController {

    @IBOutlet weak var toolbarDifficultyCheckbox: NSButton!
    @IBOutlet weak var appearancePopUp: NSPopUpButton!
    @IBOutlet weak var stylePopUp: NSPopUpButton!
    @IBOutlet weak var scaleSlider: NSSlider!
    @IBOutlet weak var safeFirstClickCheckbox: NSButton!
    @IBOutlet weak var useQuestionsCheckbox: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
        
        appearancePopUp.selectItem(withTitle: Defaults[.General.appearance])
        stylePopUp.selectItem(withTitle: Defaults[.General.style])
        scaleSlider.doubleValue = Defaults[.General.scale]
        
        if Defaults[.General.toolbarDifficulty] {
            toolbarDifficultyCheckbox.state = .on
        } else {
            toolbarDifficultyCheckbox.state = .off
        }
        
        if Defaults[.General.safeFirstClick] {
            safeFirstClickCheckbox.state = .on
        } else {
            safeFirstClickCheckbox.state = .off
        }
        
        if Defaults[.General.questions] {
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
        Defaults[.General.toolbarDifficulty].toggle()
        NotificationCenter.default.post(name: .setSubtitle, object: nil)
    }
    
    @IBAction func appearancePopUpChanged(_ sender: NSPopUpButton) {
        Defaults[.General.appearance] = sender.selectedItem!.title
    }
    
    @IBAction func stylePopUpChanged(_ sender: NSPopUpButton) {
        Defaults[.General.style] = sender.selectedItem!.title
    }
    
    @IBAction func scaleSliderChanged(_ sender: NSSlider) {
        Defaults[.General.scale] = sender.doubleValue
        NotificationCenter.default.post(name: .setScale, object: nil)
    }
    
    @IBAction func safeFirstClickCheckboxClicked(_ sender: NSButton) {
        Defaults[.General.safeFirstClick].toggle()
    }
    
    @IBAction func useQuestionsCheckboxClicked(_ sender: NSButton) {
        Defaults[.General.questions].toggle()
    }
}
