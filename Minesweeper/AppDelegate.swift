//
//  AppDelegate.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//


import Cocoa
import Sparkle
import Defaults
import SpriteKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var checkForUpdatesItem: NSMenuItem!
    let updaterController: SPUStandardUpdaterController
    let controller: ViewController = ViewController()
    
    override init() {
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
        
        // This block of code must happen before the ViewController's viewDidLoad()
        let fileManager = FileManager.default
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let msSupportURL = appSupportURL.appendingPathComponent("Minesweeper Desktop")
        var isDir = ObjCBool(true)
        
        if fileManager.fileExists(atPath: msSupportURL.path, isDirectory: &isDir) {
            do {
                try Util.readThemes()
            } catch {
                
            }
        } else {
            do {
                try fileManager.createDirectory(at: msSupportURL, withIntermediateDirectories: true, attributes: nil)
                try fileManager.createDirectory(at: Util.themesURL, withIntermediateDirectories: true, attributes: nil)
                try fileManager.createDirectory(at: msSupportURL.appendingPathComponent("Scores"), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("could not create directory")
            }
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        checkForUpdatesItem.target = updaterController
        checkForUpdatesItem.action = #selector(SPUStandardUpdaterController.checkForUpdates(_:))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.newCustomGame(notification:)), name: Notification.Name("NewCustomGame"), object: nil)
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
            Defaults[.difficulty] = sender.title
        } else {
            controller.difficulty = Defaults[.difficulty]
        }
        if let window = NSApplication.shared.mainWindow {
            if window.identifier?.rawValue == "Main" {
                window.contentViewController = controller
            }
        }
    }
    
    @IBAction func restartGame(_ sender: NSMenuItem) {
        NotificationCenter.default.post(name: .restartGame, object: nil)
    }
    
    @IBAction func customGame(_ sender: Any) {
        if let window = NSApplication.shared.mainWindow {
            if window.identifier?.rawValue == "Main" {
                let storyboard = NSStoryboard(name: "Main", bundle: nil)
                let custom = storyboard.instantiateController(withIdentifier: "customGameViewController")
                window.contentViewController?.presentAsSheet(custom as! CustomGameViewController)
            }
        }
    }
    
    @objc func newCustomGame(notification: Notification) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateController(withIdentifier: "Main") as! ViewController
        controller.difficulty = "Custom"
        Defaults[.difficulty] = "Custom"
        
        Defaults[.customDifficulty][0] = (notification.object as! [Int])[1]
        Defaults[.customDifficulty][1] = (notification.object as! [Int])[0]
        Defaults[.customDifficulty][2] = (notification.object as! [Int])[2]
        
        if let window = NSApplication.shared.mainWindow {
            window.contentViewController = controller
        }
    }
    
    @IBAction func saveBoard(_ sender: NSMenuItem) {
        
    }
    
    @IBAction func openBoard(_ sender: NSMenuItem) {
        let openPanel = NSOpenPanel()
        
        guard let window = NSApplication.shared.mainWindow else { return }

        openPanel.beginSheetModal(for: window, completionHandler: { num in
            
            if num == .OK, let path = openPanel.url {
                do {
                    let file = try Data(contentsOf: path)
                    print("File size: \(file.count) bytes")
                    
                    let rows = Int(file[1])
                    let cols = Int(file[0])
                    let mines = Int(file[3]) | Int(file[2]) << 8
                    
                    Defaults[.customDifficulty][0] = rows
                    Defaults[.customDifficulty][1] = cols
                    Defaults[.customDifficulty][2] = mines
                    
                    let storyboard = NSStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateController(withIdentifier: "Main") as! ViewController
                    
                    controller.difficulty = "Loaded Custom"
                    
                    var minesLayout: [(Int, Int)] = []
                    let minesData = file[4...]
                    
                    for i in stride(from: minesData.startIndex, to: minesData.endIndex, by: 2) {
                        if i + 1 < minesData.endIndex {
                            minesLayout.append((Int(minesData[i + 1]), Int(minesData[i])))
                        }
                    }
                    controller.minesLayout = minesLayout
                    
                    print("minesLayout: \(minesLayout)")
                    
                    window.contentViewController = controller
                    
                    print("Rows: \(Int(file[1])), Columns: \(Int(file[0])), Bombs: \(Int(file[3]) | Int(file[2]) << 8)")
                    
                } catch {
                    
                }
            }
        })
    }
}

extension Defaults.Keys {
    static let difficulty = Key<String>("difficulty", default: "Beginner")
    static let customDifficulty = Key<Array<Int>>("customDifficulty", default: [-1, -1, -1])
}
