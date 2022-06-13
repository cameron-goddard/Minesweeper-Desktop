//
//  AppDelegate.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//


import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    
    @IBAction func newGame(_ sender: NSMenuItem) {
        //print(sender.title)
        if sender.title != "New Game" {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateController(withIdentifier: "Main") as! ViewController
            controller.difficulty = sender.title
            if let window = NSApplication.shared.mainWindow {
                window.contentViewController = controller
            }
        }
    }
}
