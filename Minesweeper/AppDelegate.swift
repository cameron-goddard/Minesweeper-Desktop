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
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        checkForUpdatesItem.target = updaterController
        checkForUpdatesItem.action = #selector(SPUStandardUpdaterController.checkForUpdates(_:))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.newCustomGame(notification:)), name: Notification.Name("NewCustomGame"), object: nil)
        
        let fileManager = FileManager.default
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let msSupportURL = appSupportURL.appendingPathComponent("Minesweeper Desktop")
        var isDir = ObjCBool(true)
        
        if fileManager.fileExists(atPath: msSupportURL.path, isDirectory: &isDir) {
            do {
                let items = try fileManager.contentsOfDirectory(atPath: msSupportURL.path)
                
                for item in items {
                    if item == ".DS_Store" { continue }
                    if item == "Themes" {
                        let absoluteThemesPath = msSupportURL.appendingPathComponent(item)
                        let themes = try fileManager.contentsOfDirectory(atPath: absoluteThemesPath.path)
                        for theme in themes {
                            if theme == ".DS_Store" { continue }
                                
                            let absoluteThemePath = absoluteThemesPath.appendingPathComponent(theme)
                            print(absoluteThemePath)
                            let image = NSImage(contentsOf: absoluteThemePath)!
                            let theme = Theme(
                                name: Util.toTheme(name: absoluteThemePath.deletingPathExtension().lastPathComponent),
                                spriteSheetTexture: SKTexture(image: image),
                                backgroundColor: NSColor(red: 61, green: 61, blue: 61, alpha: 1)
                            )
                            Util.themes.append(theme)
                            
                        }
                    }
                    else if item == "Scores" {
                        
                    }
                        

                    
                }
            } catch {
                
            }
            
        } else {
            do {
                try fileManager.createDirectory(at: msSupportURL, withIntermediateDirectories: true, attributes: nil)
                
                try fileManager.createDirectory(at: msSupportURL.appendingPathComponent("Themes"), withIntermediateDirectories: true, attributes: nil)
                
                try fileManager.createDirectory(at: msSupportURL.appendingPathComponent("Scores"), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("could not create directory")
            }
        }
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
            window.contentViewController = controller
        }
    }
    
    @IBAction func customGame(_ sender: Any) {
        if let window = NSApplication.shared.mainWindow {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            let custom = storyboard.instantiateController(withIdentifier: "customGameViewController")
            window.contentViewController?.presentAsSheet(custom as! CustomGameViewController)
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
}

extension Defaults.Keys {
    static let difficulty = Key<String>("difficulty", default: "Beginner")
    static let customDifficulty = Key<Array<Int>>("customDifficulty", default: [-1, -1, -1])
}
