//
//  AppDelegate.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import Cocoa
import Defaults
import Sparkle
import SwiftUI
import UniformTypeIdentifiers

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var checkForUpdatesItem: NSMenuItem!
    let updaterController: SPUStandardUpdaterController

    private lazy var hostingController: NSHostingController<CustomGameView> = {
        let customGameView = CustomGameView(onDismiss: { [weak self] in
            guard let self else { return }
            self.hostingController.presentingViewController?.dismiss(self.hostingController)
        })
        return NSHostingController(rootView: customGameView)
    }()

    override init() {
        updaterController = SPUStandardUpdaterController(
            startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)

        super.init()

        // This block of code must happen before the ViewController's viewDidLoad()
        let fileManager = FileManager.default
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first!
        let msSupportURL = appSupportURL.appendingPathComponent("Minesweeper Desktop")
        var isDir = ObjCBool(true)

        if fileManager.fileExists(atPath: msSupportURL.path, isDirectory: &isDir) {
            do {
                try ThemeManager.shared.loadSavedThemes()
            } catch {
                let alert = NSAlert()
                alert.messageText = "Invalid Theme File"
                alert.informativeText = error.localizedDescription
                alert.runModal()

                NSApplication.shared.terminate(self)
            }
        } else {
            do {
                try fileManager.createDirectory(
                    at: msSupportURL, withIntermediateDirectories: true, attributes: nil)
                try fileManager.createDirectory(
                    at: ThemeManager.shared.themesURL, withIntermediateDirectories: true, attributes: nil
                )
                try fileManager.createDirectory(
                    at: msSupportURL.appendingPathComponent("Scores"), withIntermediateDirectories: true,
                    attributes: nil)
            } catch {
                print("could not create directory")
            }
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        checkForUpdatesItem.target = updaterController
        checkForUpdatesItem.action = #selector(SPUStandardUpdaterController.checkForUpdates(_:))

        NotificationCenter.default.addObserver(
            self, selector: #selector(self.newCustomGame(notification:)), name: .newCustomGame,
            object: nil)

        setupKeepOnTopMenuItem()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    @IBAction func newGame(_ sender: NSMenuItem) {
        let controller = NSStoryboard.main.instantiateController(withIdentifier: "Main") as! ViewController

        if sender.title != "New Game" {
            controller.difficulty = sender.title
            Defaults[.Game.difficulty] = sender.title
        } else {
            controller.difficulty = Defaults[.Game.difficulty]
        }
        if let window = NSApplication.shared.mainWindow {
            if let windowController = window.windowController as? WindowController {
                windowController.contentViewController = controller
            }
        }
    }

    @IBAction func restartGame(_ sender: NSMenuItem) {
        NotificationCenter.default.post(name: .restartGame, object: nil)
    }

    @IBAction func customGame(_ sender: NSMenuItem) {
        if let window = NSApplication.shared.mainWindow {
            if window.identifier?.rawValue == "Main" {
                window.contentViewController?.presentAsSheet(hostingController)
            }
        }
    }

    @IBAction func showBestTimes(_ sender: NSMenuItem) {
        if let window = NSApplication.shared.mainWindow {
            if window.identifier?.rawValue == "Main" {
                let bestTimes = NSStoryboard.main.instantiateController(withIdentifier: "BestTimes")
                window.contentViewController?.presentAsSheet(bestTimes as! BestTimesViewController)
            }
        }
    }

    @objc func newCustomGame(notification: Notification) {
        guard let window = NSApplication.shared.mainWindow,
            let oldController = window.contentViewController as? ViewController,
            let oldScene = oldController.getScene()
        else { return }

        let controller = NSStoryboard.main.instantiateController(withIdentifier: "Main") as! ViewController

        oldScene.gameTimer.reset()

        controller.difficulty = "Custom"
        Defaults[.Game.difficulty] = "Custom"

        Defaults[.Game.customDifficulty][0] = (notification.object as! [Int])[0]
        Defaults[.Game.customDifficulty][1] = (notification.object as! [Int])[1]
        Defaults[.Game.customDifficulty][2] = (notification.object as! [Int])[2]

        window.contentViewController = controller
    }

    @IBAction func saveBoard(_ sender: NSMenuItem) {
        guard let window = NSApplication.shared.mainWindow,
            let vc = window.contentViewController as? ViewController,
            let board = vc.getBoard()
        else { return }

        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.mbf]
        savePanel.nameFieldStringValue = "board.mbf"

        savePanel.beginSheetModal(
            for: window,
            completionHandler: { num in
                if num == .OK, let url = savePanel.url {
                    do {
                        try board.serialize().write(to: url)
                    } catch {
                        let alert = NSAlert()
                        alert.messageText = "Board Save Error"
                        alert.informativeText = "Could not write the board to a file."
                        alert.runModal()
                    }
                }
            })
    }

    @IBAction func openBoard(_ sender: NSMenuItem) {
        guard let window = NSApplication.shared.mainWindow else { return }

        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [.mbf]

        openPanel.beginSheetModal(
            for: window,
            completionHandler: { num in
                if num == .OK, let url = openPanel.url {
                    self.openFromURL(url)
                }
            })
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        openFromURL(urls[0])
    }

    private func openFromURL(_ url: URL) {
        guard let window = NSApplication.shared.mainWindow,
            let oldController = window.contentViewController as? ViewController,
            let oldScene = oldController.getScene()
        else { return }

        do {
            let file = try Data(contentsOf: url)
            if file.count < 4 {
                throw NSError.invalidBoardError()
            }

            let rows = Int(file[1])
            let cols = Int(file[0])
            if rows == 0 || cols == 0 {
                throw NSError.invalidBoardError()
            }

            let mines = Int(file[3]) | Int(file[2]) << 8
            if mines > rows * cols {
                throw NSError.invalidBoardError()
            }

            let minesData = file[4...]
            if minesData.count != mines * 2 {
                throw NSError.invalidBoardError()
            }

            var minesLayout: [(Int, Int)] = []
            for i in stride(from: minesData.startIndex, to: minesData.endIndex, by: 2) {
                if i + 1 < minesData.endIndex {
                    minesLayout.append((Int(minesData[i + 1]), Int(minesData[i])))
                }
            }

            Defaults[.Game.customDifficulty][0] = rows
            Defaults[.Game.customDifficulty][1] = cols
            Defaults[.Game.customDifficulty][2] = mines

            oldScene.gameTimer.reset()

            let controller =
                NSStoryboard.main.instantiateController(withIdentifier: "Main") as! ViewController

            controller.difficulty = "Loaded Custom"
            controller.minesLayout = minesLayout

            window.contentViewController = controller
        } catch {
            let alert = NSAlert()
            alert.messageText = "Invalid Board File"
            alert.informativeText = error.localizedDescription
            alert.runModal()
        }
    }

    @IBAction func showStats(_ sender: NSMenuItem) {
        guard let window = NSApplication.shared.mainWindow,
            let windowController = window.windowController as? WindowController
        else { return }

        windowController.toggleStatsWindow()
    }

    @IBAction func showReleaseNotes(_ sender: NSMenuItem) {
        NSWorkspace.shared.open(URL(string: "https://www.camerongoddard.com/ms-desktop/release_notes.html")!)
    }

    private func setupKeepOnTopMenuItem() {
        guard let windowMenu = NSApplication.shared.windowsMenu else { return }

        // Avoid duplicate insertion if called more than once
        if windowMenu.items.contains(where: { $0.action == #selector(toggleKeepOnTop(_:)) }) {
            return
        }

        let item = NSMenuItem(title: "Keep on Top", action: #selector(toggleKeepOnTop(_:)), keyEquivalent: "")

        item.target = self
        item.image = NSImage(systemSymbolName: "rectangle.badge.plus", accessibilityDescription: nil)

        windowMenu.addItem(.separator())
        windowMenu.addItem(item)
    }

    @objc func toggleKeepOnTop(_ sender: NSMenuItem) {
        guard let window = NSApplication.shared.keyWindow else { return }
        let shouldFloat = window.level != .floating
        window.level = shouldFloat ? .floating : .normal
        // Persist preference when toggling the main game window
        if window.identifier?.rawValue == "Main" {
            Defaults[.General.keepOnTop] = shouldFloat
        }
    }
}

extension UTType {
    public static let mbf = UTType(exportedAs: "com.camerongoddard.Minesweeper.mbf")
}

extension NSStoryboard {
    static var main: NSStoryboard {
        return NSStoryboard(name: "Main", bundle: nil)
    }
}

extension AppDelegate: NSMenuItemValidation {
    func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        if menuItem.action == #selector(toggleKeepOnTop(_:)) {
            if let window = NSApplication.shared.keyWindow {
                menuItem.state = (window.level == .floating) ? .on : .off
                return true
            } else {
                menuItem.state = .off
                return false
            }
        }
        return true
    }
}
