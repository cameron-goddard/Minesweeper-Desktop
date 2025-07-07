//
//  AppDelegate.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import Cocoa
import Defaults
import Sparkle
import UniformTypeIdentifiers
import SwiftUI

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
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    @IBAction func newGame(_ sender: NSMenuItem) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateController(withIdentifier: "Main") as! ViewController

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

    @objc func newCustomGame(notification: Notification) {
        guard let window = NSApplication.shared.mainWindow,
            let oldController = window.contentViewController as? ViewController,
            let oldScene = oldController.getScene()
        else { return }

        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateController(withIdentifier: "Main") as! ViewController

        oldScene.gameTimer.reset()

        controller.difficulty = "Custom"
        Defaults[.Game.difficulty] = "Custom"

        Defaults[.Game.customDifficulty][0] = (notification.object as! [Int])[1]
        Defaults[.Game.customDifficulty][1] = (notification.object as! [Int])[0]
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
                if num == .OK, let path = savePanel.url {
                    var data = Data()

                    data.append(UInt8(board.cols))
                    data.append(UInt8(board.rows))

                    let mines = UInt16(board.mines)

                    data.append(UInt8((mines >> 8) & 0xFF))
                    data.append(UInt8(mines & 0xFF))

                    for (r, c) in board.minesLayout {
                        data.append(UInt8(c))
                        data.append(UInt8(r))
                    }

                    do {
                        try data.write(to: path)
                    } catch {

                    }
                }
            })
    }

    @IBAction func openBoard(_ sender: NSMenuItem) {
        guard let window = NSApplication.shared.mainWindow,
            let oldController = window.contentViewController as? ViewController,
            let oldScene = oldController.getScene()
        else { return }

        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [.mbf]

        openPanel.beginSheetModal(
            for: window,
            completionHandler: { num in
                if num == .OK, let path = openPanel.url {
                    do {
                        let file = try Data(contentsOf: path)
                        if file.count < 4 {
                            self.showInvalidBoardAlert()
                            return
                        }

                        let rows = Int(file[1])
                        let cols = Int(file[0])
                        if rows == 0 || cols == 0 {
                            self.showInvalidBoardAlert()
                            return
                        }

                        let mines = Int(file[3]) | Int(file[2]) << 8
                        if mines > rows * cols {
                            self.showInvalidBoardAlert()
                            return
                        }

                        var minesLayout: [(Int, Int)] = []
                        let minesData = file[4...]
                        if minesData.count != mines * 2 {
                            self.showInvalidBoardAlert()
                            return
                        }

                        for i in stride(from: minesData.startIndex, to: minesData.endIndex, by: 2) {
                            if i + 1 < minesData.endIndex {
                                minesLayout.append((Int(minesData[i + 1]), Int(minesData[i])))
                            }
                        }

                        oldScene.gameTimer.reset()

                        Defaults[.Game.customDifficulty][0] = rows
                        Defaults[.Game.customDifficulty][1] = cols
                        Defaults[.Game.customDifficulty][2] = mines

                        let storyboard = NSStoryboard(name: "Main", bundle: nil)
                        let controller =
                            storyboard.instantiateController(withIdentifier: "Main") as! ViewController

                        controller.difficulty = "Loaded Custom"
                        controller.minesLayout = minesLayout

                        window.contentViewController = controller
                    } catch {
                        self.showInvalidBoardAlert()
                    }
                }
            })
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        // TODO
    }

    private func showInvalidBoardAlert() {
        let alert = NSAlert()
        alert.messageText = "Invalid Board File"
        alert.informativeText = "The selected file is not a valid Minesweeper board."
        alert.runModal()
    }
}

extension UTType {
    public static let mbf = UTType(exportedAs: "com.camerongoddard.Minesweeper.mbf")
}
