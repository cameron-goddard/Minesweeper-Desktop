//
//  ThemesViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/19/22.
//

import Cocoa
import GameplayKit

class ThemesViewController: NSViewController {

    
    @IBOutlet weak var tableView: NSTableView!
    var themes: [Theme] = Util.themes
    @IBOutlet weak var themePreview: SKView!
    @IBOutlet weak var themeName: NSTextField!
    @IBOutlet weak var themeDesc: NSTextField!
    @IBOutlet weak var themeFavorite: NSButton!
    @IBOutlet weak var themeDefault: NSTextField!
    @IBOutlet weak var themeStyle: NSTextField!
    @IBOutlet weak var themeMode: NSTextField!
    @IBOutlet weak var assetsTableView: NSTableView!
    @IBOutlet weak var addDeleteControl: NSSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
        themePreview.wantsLayer = true
        themePreview.layer?.cornerRadius = 5
        assetsTableView.enclosingScrollView?.wantsLayer = true
        assetsTableView.enclosingScrollView?.layer?.cornerRadius = 5
        showThemeInfo()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "Themes"
    }
    
    func showThemeInfo() {
        let theme = themes[tableView.selectedRow]
        
        themeName.stringValue = theme.name
        themeDesc.stringValue = theme.desc
        //themeDefault.stringValue = theme.isDefault.
        themeStyle.stringValue = theme.style
        themeMode.stringValue = theme.mode
        themePreview.presentScene(ThemeScene(theme: theme))
        
        if theme.isDefault {
            addDeleteControl.setEnabled(false, forSegment: 1)
        }
        
    }
    
    @IBAction func favoriteButtonPressed(_ sender: NSButton) {
        let unpressedConfig = NSImage.SymbolConfiguration(paletteColors: [.controlAccentColor, .tertiaryLabelColor, .quaternaryLabelColor])
        let pressedConfig = NSImage.SymbolConfiguration(paletteColors: [.white, .tertiaryLabelColor, .controlAccentColor])
        
        if sender.state == .on {
            sender.image = sender.image!.withSymbolConfiguration(pressedConfig)
        } else {
            sender.image = sender.image!.withSymbolConfiguration(unpressedConfig)
        }
    }
    
    @IBAction func addDeleteControlPressed(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            let openPanel = NSOpenPanel()
            
            openPanel.beginSheetModal(for: self.view.window!, completionHandler: { num in
                if num == .OK {
                    let path = openPanel.url
                    print(path)
                } else {
                    print("nothing chosen")
                }
            })
        }
        
    }
}

extension ThemesViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return themes.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let themeCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "themeCell"), owner: self) as? NSTableCellView else { return nil }
        themeCell.textField?.stringValue = themes[row].name
        return themeCell
    }
}

extension ThemesViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        showThemeInfo()
    }
}
