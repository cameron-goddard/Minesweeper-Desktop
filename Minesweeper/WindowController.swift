//
//  WindowController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/24/22.
//

import Cocoa
import Defaults

class WindowController: NSWindowController {
    
    @IBOutlet weak var toolbar: NSToolbar!
    
    // There is a bug in the way macOS handles adding to NSMenu, see updateThemeMenu
    let themesItem: NSMenuToolbarItem = {
        let item = NSMenuToolbarItem(itemIdentifier: .toolbarThemesMenuItem)
        item.toolTip = "Themes"
        item.image = NSImage(systemSymbolName: "paintbrush", accessibilityDescription: nil)
        item.label = "Themes"
        return item
    }()
    
    private var statsController: StatsWindowController = {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateController(withIdentifier: "Stats") as! StatsWindowController
    }()
    
    var viewController : ViewController {
        self.contentViewController as! ViewController
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateThemeMenu(notification:)), name: Notification.Name("UpdateThemeMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setTheme(notification:)), name: Notification.Name("SetTheme"), object: nil)
    }
    
    @objc func showStatsWindow() {
        if statsController.window!.isVisible {
            statsController.window?.close()
            statsController.dismissController(self)
        } else {
            statsController.showWindow(self)
            // TODO: Handle edge cases for screen edge
            let x = self.window!.frame.origin.x + self.window!.frame.width + 25
            let y = self.window!.frame.origin.y + self.window!.frame.height
            statsController.window!.setFrameTopLeftPoint(.init(x: x, y: y))
        }
    }
    
    @objc func changeTheme(sender: NSMenuItem) {
        Util.currentTheme = Util.theme(withName: sender.title)
        Defaults[.theme] = sender.title
        
        for item in sender.menu!.items {
            if item.state == .on {
                item.state = .off
            }
        }
        sender.state = .on
        (viewController.skView.scene as! GameScene).setTextures()
    }
    
    @objc func updateThemeMenu(notification: Notification) {
        // There is a bug in the way macOS handles menu updates. When it is fixed,
        // this method should be as simple as this:
        //themesMenu.items.append(NSMenuItem(title: Util.themes[Util.themes.count - 1].name, action: #selector(changeTheme(sender:)), keyEquivalent: ""))
        let tempMenu = NSMenu()
        tempMenu.autoenablesItems = false
        
        let titleItem = tempMenu.addItem(withTitle: "Themes", action: nil, keyEquivalent: "")
        titleItem.isEnabled = false
        let font = NSFont.systemFont(ofSize: 11, weight: .semibold)
        titleItem.attributedTitle = NSAttributedString(string: "Themes", attributes: [.font: font])
        
        for theme in Util.themes {
            if Defaults[.favorites].contains(theme.name) {
                let menuItem = tempMenu.addItem(withTitle: theme.name, action: #selector(changeTheme(sender:)), keyEquivalent: "")
                if Util.currentTheme == Util.theme(withName: theme.name) {
                    menuItem.state = .on
                }
            }
        }
        themesItem.menu = tempMenu
    }
    
    @objc func setTheme(notification: Notification) {
        Util.currentTheme = Util.theme(withName: notification.object as! String)
        Defaults[.theme] = notification.object as! String
        
        (viewController.skView.scene as! GameScene).setTextures()
    }
}

extension WindowController: NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        if itemIdentifier == .toolbarShareButtonItem {
            let item = NSSharingServicePickerToolbarItem(itemIdentifier: itemIdentifier)
            item.delegate = self
            item.menuFormRepresentation?.image = NSImage(systemSymbolName: "square.and.arrow.up", accessibilityDescription: nil)
            return item
        }
        
        if itemIdentifier == .toolbarThemesMenuItem {
            let themesMenu = NSMenu(title: "Themes")
            themesMenu.autoenablesItems = false
            
            let titleItem = themesMenu.addItem(withTitle: "Themes", action: nil, keyEquivalent: "")
            titleItem.isEnabled = false
            let font = NSFont.systemFont(ofSize: 11, weight: .semibold)
            titleItem.attributedTitle = NSAttributedString(string: "Themes", attributes: [.font: font])
            
            for theme in Util.themes {
                if Defaults[.favorites].contains(theme.name) {
                    let menuItem = themesMenu.addItem(withTitle: theme.name, action: #selector(changeTheme(sender:)), keyEquivalent: "")
                    if Util.currentTheme == Util.theme(withName: theme.name) {
                        menuItem.state = .on
                    }
                }
            }
            //themesMenu.addItem(.init(title: "Show All...", action: nil, keyEquivalent: ""))
            themesItem.menu = themesMenu
            
            return themesItem
        }
        if itemIdentifier == .toolbarStatsItem {
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.label = "Stats"
            item.toolTip = "Stats"
            item.isBordered = true
            item.image = NSImage(systemSymbolName: "chart.bar", accessibilityDescription: nil)
            item.action = #selector(showStatsWindow)
            return item
        }
        return nil
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .toolbarStatsItem,
            .toolbarThemesMenuItem,
            .toolbarShareButtonItem
        ]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .toolbarStatsItem,
            .toolbarThemesMenuItem,
            .toolbarShareButtonItem
        ]
    }
}

extension WindowController: NSSharingServicePickerToolbarItemDelegate {
    
    func items(for pickerToolbarItem: NSSharingServicePickerToolbarItem) -> [Any] {
        let sharableItems = [URL(string: "https://www.apple.com/")!]
        return sharableItems
    }
}

extension NSToolbar.Identifier {
    static let mainWindowToolbar = NSToolbar.Identifier("MainWindowToolbar")
}

extension NSToolbarItem.Identifier {
    static let toolbarShareButtonItem = NSToolbarItem.Identifier(rawValue: "ToolbarShareButtonItem")
    static let toolbarThemesMenuItem = NSToolbarItem.Identifier(rawValue: "ToolbarThemesMenuItem")
    static let toolbarStatsItem = NSToolbarItem.Identifier(rawValue: "ToolbarStatsItem")
}

extension Defaults.Keys {
    static let theme = Key<String>("theme", default: "Classic")
}
