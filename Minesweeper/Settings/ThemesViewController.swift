//
//  ThemesViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/19/22.
//

import Cocoa
import GameplayKit
import Defaults

class ThemesViewController: NSViewController {

    @IBOutlet weak var tabView: NSTabView!
    
    @IBOutlet weak var tableView: NSTableView!
    var themes: [Theme] = Util.themes
    
    @IBOutlet weak var themePreview: SKView!
    @IBOutlet weak var themeName: NSTextField!
    @IBOutlet weak var themeDesc: NSTextField!
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
        themeDefault.stringValue = theme.isDefault ? "Yes" : "No"
        themeStyle.stringValue = theme.style
        themeMode.stringValue = theme.mode
        themePreview.presentScene(ThemeScene(theme: theme))
        
        if theme.isDefault {
            addDeleteControl.setEnabled(false, forSegment: 1)
        } else {
            addDeleteControl.setEnabled(true, forSegment: 1)
        }
    }
    
    @IBAction func addDeleteControlPressed(_ sender: NSSegmentedControl) {
        let fileManager = FileManager.default
        
        // TODO: Move directoryURL to Util
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let directoryURL = appSupportURL.appendingPathComponent("Minesweeper Desktop")
        let themesURL = directoryURL.appendingPathComponent("Themes")
        
        if sender.selectedSegment == 0 {
            let openPanel = NSOpenPanel()
            
            openPanel.beginSheetModal(for: self.view.window!, completionHandler: { num in
                if num == .OK {
                    let path = openPanel.url
                    let file = NSData(contentsOf: path!)
                    do {
                        let documentURL = themesURL.appendingPathComponent((path?.absoluteString as! NSString).lastPathComponent)
                        try file!.write(to: documentURL)
                        try Util.readThemes()
                        
                        self.themes = Util.themes
                        self.tableView.reloadData()
                        
                    } catch {
                        print("could not write to file")
                    }
                } else {
                    print("nothing chosen")
                }
            })
        } else {
            do {
                let name = "\(themes[tableView.selectedRow].pathName).jpeg"
                let fileURL = themesURL.appendingPathComponent(name)
                try fileManager.removeItem(atPath: fileURL.path)
                
                let oldRow = tableView.selectedRow
                // TODO: Investigate this bug: Delete a favorited item, add any other back in
                Util.themes.remove(at: Util.themes.firstIndex(of: themes[oldRow])!)
                if let index = Defaults[.favorites].firstIndex(of: themes[oldRow].name) {
                    Defaults[.favorites].remove(at: index)
                }
                NotificationCenter.default.post(name: Notification.Name("UpdateThemeMenu"), object: nil)
                themes.remove(at: themes.firstIndex(of: themes[oldRow])!)
                
                tableView.reloadData()
                // This shouldn't be an issue since there are non-removable default themes, but be wary of this
                tableView.selectRowIndexes([oldRow - 1], byExtendingSelection: false)
            } catch {
                print("could not delete file")
            }
        }
    }
    
    @IBAction func setThemeButtonPressed(_ sender: Any) {
        Util.currentTheme = themes[tableView.selectedRow]
        Defaults[.theme] = themes[tableView.selectedRow].name
        
        NotificationCenter.default.post(name: Notification.Name("SetTheme"), object: themes[tableView.selectedRow].name)
    }
}

extension ThemesViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == self.tableView {
            return themes.count
        } else {
            return 36
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if tableView == self.tableView {
            guard let themeCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "themeCell"), owner: self) as? ThemeCellView else { return nil }
            themeCell.themeName.stringValue = themes[row].name
            
            if themes[row].isFavorite {
                themeCell.setFavorite()
            }
            
            return themeCell
        } else {
            guard let assetCell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "assetCell"), owner: self) as? AssetCellView else { return nil }
            //print(self.tableView.selectedRow)
            let current = themes[self.tableView.selectedRow]
            let tilesMirror = Mirror(reflecting: current.tiles)
            let mainButtonMirror = Mirror(reflecting: current.mainButton)
            // let numbersMirror = Mirror(reflecting: current.numbers)
            let bordersMirror = Mirror(reflecting: current.borders)
            
            
            let mirrors = [tilesMirror, mainButtonMirror, bordersMirror]
            
            var assetLabels : [String] = []
            var assetImages : [SKTexture] = []
            
            for m in mirrors {
                assetLabels += m.children.map({ $0.label! })
                assetImages += m.children.map({ $0.value as! SKTexture })
            }
            
            //let assetLabels = mirror.children.map({ $0.label! })
            //let assetImages = mirror.children.map({ $0.value as! SKTexture })
            //print(assetImages)
            assetCell.assetName.stringValue = assetLabels[row]
            assetCell.assetPreview.presentScene(AssetScene(asset: assetImages[row]))
            
            return assetCell
        }
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if tableView == self.tableView {
            return 20
        } else {
            return 36
        }
    }
}

extension ThemesViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        showThemeInfo()
    }
}

extension ThemesViewController: NSTabViewDelegate {
    
    func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        if tabViewItem!.label == "Assets" {
            assetsTableView.reloadData()
        }
    }
}
