//
//  AssetCellView.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 1/12/23.
//

import Cocoa
import GameplayKit

class AssetCellView: NSTableCellView {

    @IBOutlet weak var assetPreview: SKView!
    @IBOutlet weak var assetName: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
    }
    
}
