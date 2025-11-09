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

    // There is a bug in the way macOS handles adding to NSMenu, see updateThemesMenu
    let themesItem: NSMenuToolbarItem = {
        let item = NSMenuToolbarItem(itemIdentifier: .toolbarThemesMenuItem)
        item.label = "Themes"
        item.toolTip = "Themes"

        if #available(macOS 26.0, *) {
            item.image = NSImage(systemSymbolName: "paintbrush", accessibilityDescription: nil)?
                .withSymbolConfiguration(.init(scale: .medium))
        } else {
            item.image = NSImage(systemSymbolName: "paintbrush", accessibilityDescription: nil)
        }

        return item
    }()

    private var statsWC: NSWindowController = {
        NSStoryboard.main.instantiateController(withIdentifier: "Stats") as! NSWindowController
    }()

    var viewController: ViewController {
        self.contentViewController as! ViewController
    }

    override var contentViewController: NSViewController? {
        willSet {
            // Invalidate the game timer before the view controller is killed
            if let gameScene = viewController.getScene() {
                gameScene.gameTimer.stop()
            }
        }
        didSet {
            // Reset the game timer and all stats when a new view controller is created
            if let statsVC = statsWC.contentViewController as? StatsViewController {
                if let gameScene = viewController.getScene() {
                    gameScene.gameTimer.delegate = statsVC
                    gameScene.gameTimer.reset()
                    NotificationCenter.default.post(name: .resetStats, object: nil)
                }
            }
        }
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        NotificationCenter.default.addObserver(
            self, selector: #selector(self.updateFavorites(_:)), name: .updateFavorites,
            object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.setTheme(notification:)), name: .setTheme, object: nil)
        DistributedNotificationCenter.default().addObserver(
            self, selector: #selector(interfaceThemeChanged), name: .appleInterfaceThemeChanged,
            object: nil)

        if let zoomButton = window?.standardWindowButton(.zoomButton) {
            zoomButton.target = self
            zoomButton.action = #selector(zoomButtonClicked(_:))
        }
        
        // Apply persisted "Always on Top" preference
        if Defaults[.General.alwaysOnTop] {
            window?.level = .floating
        } else {
            window?.level = .normal
        }
    }

    @objc func zoomButtonClicked(_ sender: Any?) {
        if Defaults[.General.scale] != 2 {
            Defaults[.General.scale] = 2
        } else {
            Defaults[.General.scale] = 1.5
        }
        NotificationCenter.default.post(name: .setScale, object: nil)
    }

    @objc func interfaceThemeChanged() {
        if Defaults[.General.appearance] != "System" {
            return
        }

        if UserDefaults.standard.string(forKey: "AppleInterfaceStyle") != nil {
            if ThemeManager.shared.current.name == "Classic" {
                ThemeManager.shared.setCurrent(with: "Classic Dark")
                Defaults[.Themes.theme] = "Classic Dark"
            }
        } else {
            if ThemeManager.shared.current.name == "Classic Dark" {
                ThemeManager.shared.setCurrent(with: "Classic")
                Defaults[.Themes.theme] = "Classic"
            }
        }

        if let gameScene = viewController.getScene() {
            gameScene.updateTextures()
        }
        updateThemesMenu()
    }

    @objc func showStatsWindow() {
        if let statsVC = statsWC.contentViewController as? StatsViewController {
            if let gameScene = viewController.getScene() {
                gameScene.gameTimer.delegate = statsVC
            }
        }

        if statsWC.window!.isVisible {
            statsWC.window?.close()
            statsWC.dismissController(self)
        } else {
            statsWC.showWindow(self)
            // TODO: Handle edge cases for screen edge
            let x = self.window!.frame.origin.x + self.window!.frame.width + 25
            let y = self.window!.frame.origin.y + self.window!.frame.height
            statsWC.window!.setFrameTopLeftPoint(.init(x: x, y: y))
        }
    }

    @objc func setTheme(sender: NSMenuItem) {
        ThemeManager.shared.setCurrent(with: sender.title)
        Defaults[.Themes.theme] = sender.title

        if let gameScene = viewController.getScene() {
            gameScene.updateTextures()
        }
        updateThemesMenu()
    }

    @objc func setTheme(notification: Notification) {
        ThemeManager.shared.setCurrent(with: notification.object as! String)
        Defaults[.Themes.theme] = notification.object as! String

        if let gameScene = viewController.getScene() {
            gameScene.updateTextures()
        }
        updateThemesMenu()
    }

    @objc func updateFavorites(_: Notification) {
        updateThemesMenu()
    }

    func updateThemesMenu() {
        // There is a bug in the way macOS handles menu updates. When it is fixed,
        // this method should probably just modify the existing menu instead of copying it
        let tempMenu = NSMenu()
        tempMenu.autoenablesItems = false

        let titleItem = tempMenu.addItem(withTitle: "Themes", action: nil, keyEquivalent: "")
        titleItem.isEnabled = false
        let font = NSFont.systemFont(ofSize: 11, weight: .semibold)
        titleItem.attributedTitle = NSAttributedString(string: "Themes", attributes: [.font: font])

        for theme in ThemeManager.shared.themes {
            if Defaults[.Themes.favorites].contains(theme.name) {
                let menuItem = tempMenu.addItem(
                    withTitle: theme.name, action: #selector(setTheme(sender:)), keyEquivalent: "")
                if ThemeManager.shared.current == ThemeManager.shared.theme(with: theme.name) {
                    menuItem.state = .on
                }
            }
        }
        if !ThemeManager.shared.current.isFavorite {
            tempMenu.addItem(.separator())
            let menuItem = tempMenu.addItem(
                withTitle: ThemeManager.shared.current.name, action: #selector(setTheme(sender:)),
                keyEquivalent: "")
            menuItem.state = .on
        }
        //themesMenu.addItem(.init(title: "Show All...", action: nil, keyEquivalent: ""))
        themesItem.menu = tempMenu
    }
}

extension WindowController: NSToolbarDelegate {
    func toolbar(
        _ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? {

        if itemIdentifier == .toolbarShareButtonItem {
            let item = NSSharingServicePickerToolbarItem(itemIdentifier: itemIdentifier)
            item.delegate = self

            let shareImage: NSImage?
            if #available(macOS 26.0, *) {
                shareImage = NSImage(
                    systemSymbolName: "square.and.arrow.up", accessibilityDescription: nil)?
                    .withSymbolConfiguration(.init(scale: .medium))
                item.image = shareImage
            } else {
                shareImage = NSImage(
                    systemSymbolName: "square.and.arrow.up", accessibilityDescription: nil)
            }
            item.menuFormRepresentation?.image = shareImage

            return item
        }

        if itemIdentifier == .toolbarThemesMenuItem {
            updateThemesMenu()
            return themesItem
        }
        if itemIdentifier == .toolbarStatsItem {
            let item = NSToolbarItem(itemIdentifier: itemIdentifier)
            item.label = "Stats"
            item.toolTip = "Stats"
            item.isBordered = true
            if #available(macOS 26.0, *) {
                item.image = NSImage(systemSymbolName: "chart.bar", accessibilityDescription: nil)?
                    .withSymbolConfiguration(.init(scale: .medium))
            } else {
                item.image = NSImage(systemSymbolName: "chart.bar", accessibilityDescription: nil)
            }
            item.action = #selector(showStatsWindow)
            return item
        }
        return nil
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .toolbarStatsItem,
            .toolbarThemesMenuItem,
            .toolbarShareButtonItem,
        ]
    }

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [
            .toolbarStatsItem,
            .toolbarThemesMenuItem,
            .toolbarShareButtonItem,
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