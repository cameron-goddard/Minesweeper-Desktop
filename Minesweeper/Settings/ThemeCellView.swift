//
//  ThemeCellView.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 10/7/23.
//

import Cocoa
import Defaults

class ThemeCellView: NSTableCellView {

    @IBOutlet weak var themeName: NSTextField!
    @IBOutlet weak var themeFavorite: NSButton!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if themeFavorite.state == .off {
            themeFavorite.isHidden = true
        }
        
        // Drawing code here.
    }
    
    override func mouseEntered(with theEvent: NSEvent) {
        super.mouseEntered(with: theEvent)
        themeFavorite.isHidden = false
    }
    
    override func mouseExited(with theEvent: NSEvent) {
        super.mouseExited(with: theEvent)
        
        if themeFavorite.state == .off {
            themeFavorite.isHidden = true
        }
    }
    
    func setUpTrackingArea() {
        let trackingArea = NSTrackingArea(rect: self.frame, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setUpTrackingArea()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpTrackingArea()
    }
    
    @IBAction func favoriteButtonPressed(_ sender: NSButton) {
        if sender.state == .off {
            themeFavorite.image = .init(systemSymbolName: "star", accessibilityDescription: nil)
            Defaults[.favorites].remove(at: Defaults[.favorites].firstIndex(of: themeName.stringValue)!)
        } else {
            themeFavorite.image = .init(systemSymbolName: "star.fill", accessibilityDescription: nil)
            Defaults[.favorites].append(themeName.stringValue)
        }
        NotificationCenter.default.post(name: Notification.Name("UpdateFavorites"), object: nil)
    }
    
    func setFavorite() {
        themeFavorite.state = .on
        themeFavorite.image = .init(systemSymbolName: "star.fill", accessibilityDescription: nil)
    }
}
