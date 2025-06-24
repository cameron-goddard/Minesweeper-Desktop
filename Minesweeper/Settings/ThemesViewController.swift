//
//  ThemesViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/19/22.
//

import Cocoa
import GameplayKit
import Defaults
import UniformTypeIdentifiers

class ThemesViewController: NSViewController {

    @IBOutlet weak var tabView: NSTabView!
    
    @IBOutlet weak var tableView: NSTableView!
    var themes: [Theme] = ThemeManager.shared.themes
    
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
        tableView.doubleAction = #selector(setThemeButtonPressed(_:))
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
        if sender.selectedSegment == 0 {
            let openPanel = NSOpenPanel()
            openPanel.allowedContentTypes = [
                UTType(filenameExtension: "bmp")!,
                UTType(filenameExtension: "png")!,
                UTType(filenameExtension: "jpg")!,
                UTType(filenameExtension: "jpeg")!,
            ]

            openPanel.beginSheetModal(for: self.view.window!, completionHandler: { num in
                if num == .OK {
                    let path = openPanel.url
                    let file = NSData(contentsOf: path!)
                    do {
                        let themeURL = ThemeManager.shared.themesURL.appendingPathComponent((path?.absoluteString as! NSString).lastPathComponent)
                        try file!.write(to: themeURL)
                        
                        let fileName = themeURL.lastPathComponent
                        
                        if !ThemeManager.shared.themes.contains(where: {$0.fileName == fileName}) {
                            try ThemeManager.shared.addTheme(fileName: fileName)
                        } else {
                            let alert = NSAlert()
                            alert.messageText = "Duplicate theme"
                            alert.informativeText = "A theme with this name already exists!"
                            alert.runModal()
                        }
                        // tableView.reloadData() messes up the favorite buttons - possibly investigate
                        self.themes = ThemeManager.shared.themes
                        self.tableView.insertRows(at: IndexSet(integer: ThemeManager.shared.themes.count - 1))
                    } catch {
                        print("could not write to file")
                    }
                } else {
                    print("nothing chosen")
                }
            })
        } else {
            do {
                let name = themes[tableView.selectedRow].fileName
                let fileURL = ThemeManager.shared.themesURL.appendingPathComponent(name)
                try FileManager.default.removeItem(atPath: fileURL.path)
                
                let oldRow = tableView.selectedRow
                // TODO: Investigate this bug: Delete a favorited item, add any other back in
                ThemeManager.shared.themes.remove(at: ThemeManager.shared.themes.firstIndex(of: themes[oldRow])!)
                if let index = Defaults[.favorites].firstIndex(of: themes[oldRow].name) {
                    Defaults[.favorites].remove(at: index)
                }
                themes.remove(at: themes.firstIndex(of: themes[oldRow])!)
                NotificationCenter.default.post(name: Notification.Name("UpdateFavorites"), object: nil)
                // This shouldn't be an issue since there are non-removable default themes, but be wary of this
                tableView.selectRowIndexes([oldRow - 1], byExtendingSelection: false)
                tableView.removeRows(at: IndexSet(integer: oldRow))
            } catch {
                print("could not delete file")
            }
        }
    }
    
    @IBAction func setThemeButtonPressed(_ sender: Any) {
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
