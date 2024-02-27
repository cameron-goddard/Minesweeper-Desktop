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
    @IBOutlet weak var safeFirstClickCheckbox: NSButton!
    @IBOutlet weak var useQuestionsCheckbox: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
        
        appearancePopUp.selectItem(withTitle: Defaults[.appearance])
        stylePopUp.selectItem(withTitle: Defaults[.style])
        
        if Defaults[.toolbarDifficulty] {
            toolbarDifficultyCheckbox.state = .on
        } else {
            toolbarDifficultyCheckbox.state = .off
        }
        
        if Defaults[.safeFirstClick] {
            safeFirstClickCheckbox.state = .on
        } else {
            safeFirstClickCheckbox.state = .off
        }
        
        if Defaults[.questions] {
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
        Defaults[.toolbarDifficulty].toggle()
        NotificationCenter.default.post(name: Notification.Name("SetSubtitle"), object: nil)
    }
    
    @IBAction func appearancePopUpChanged(_ sender: NSPopUpButton) {
        Defaults[.appearance] = sender.selectedItem!.title
    }
    
    @IBAction func stylePopUpChanged(_ sender: NSPopUpButton) {
        Defaults[.style] = sender.selectedItem!.title
    }
    
    @IBAction func safeFirstClickCheckboxClicked(_ sender: NSButton) {
        Defaults[.safeFirstClick].toggle()
    }
    
    @IBAction func useQuestionsCheckboxClicked(_ sender: NSButton) {
        Defaults[.questions].toggle()
    }
}

extension Defaults.Keys {
    static let appearance = Key<String>("appearance", default: "System")
    static let style = Key<String>("style", default: "Classic")
    static let toolbarDifficulty = Key<Bool>("toolbarDifficulty", default: false)
    static let questions = Key<Bool>("questions", default: false)
    static let safeFirstClick = Key<Bool>("safeFirstClick", default: true)
}
