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
    
    var viewController : ViewController {
        self.contentViewController as! ViewController
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        //initAccessoryView()
    }
    
    @objc func showStatsWindow() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateController(withIdentifier: "Stats") as! StatsWindowController
        controller.showWindow(self)
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
}

extension WindowController {
    
    func initAccessoryView() {
        if let accessoryView = self.storyboard?.instantiateController(withIdentifier: "AccessoryViewController") as? AccessoryViewController {
            accessoryView.layoutAttribute = .bottom
            self.window?.addTitlebarAccessoryViewController(accessoryView)
            accessoryView.isHidden = false
        }
    }
    
}

extension WindowController: NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        if itemIdentifier == NSToolbarItem.Identifier.toolbarShareButtonItem {
            let item = NSSharingServicePickerToolbarItem(itemIdentifier: itemIdentifier)
            item.delegate = self
            item.menuFormRepresentation?.image = NSImage(systemSymbolName: "square.and.arrow.up", accessibilityDescription: nil)
            return item
        }
        
        if itemIdentifier == NSToolbarItem.Identifier.toolbarThemesMenuItem {
            let item = NSMenuToolbarItem(itemIdentifier: itemIdentifier)
            item.toolTip = "Themes"
            item.image = NSImage(systemSymbolName: "paintbrush", accessibilityDescription: nil)
            
            item.label = "Themes"
            let themesMenu = NSMenu(title: "Themes")
            themesMenu.autoenablesItems = false
            
            let titleItem = themesMenu.addItem(withTitle: "Themes", action: nil, keyEquivalent: "")
            titleItem.isEnabled = false
            let font = NSFont.systemFont(ofSize: 11, weight: .semibold)
            titleItem.attributedTitle = NSAttributedString(string: "Themes", attributes: [.font: font])
            
            for item in Util.themes {
                let menuItem = themesMenu.addItem(withTitle: item.name, action: nil, keyEquivalent: "")
                menuItem.action = #selector(changeTheme(sender:))
            }
            themesMenu.items[1].state = .on
            item.menu = themesMenu
            
            return item
        }
        if itemIdentifier == NSToolbarItem.Identifier.toolbarStatsItem {
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
