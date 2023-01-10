//
//  SpriteSheet.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import Foundation
import SpriteKit

struct SpriteSheet {
    let atlas : SKTexture
    let row, columns : Int
    let rowHeights = [0:26, 1:23, 2:23, 3:16]
    let rowWidths = [0:26, 1:13, 2:13, 3:16]
    
    let borderRowHeights = [0:11, 1:12, 2:1, 3:1, 4:11, 5:12, 6:23, 7:1]
    let borderRowWidths = [0:11, 1:12, 2:11, 3:12, 4:1, 5:1, 6:1, 7:41]

    var frameSize: CGSize {
        return CGSize(
            width: CGFloat(rowWidths[row]!),
            height: CGFloat(rowHeights[row]!)
        )
    }

    func textureFor(col: Int) -> SKTexture {
        let frameSize = self.frameSize
        let atlasSize = atlas.size()
        var y = 0
        
        for i in 0..<row {
            y += rowHeights[i]!
        }

        let textureRect = CGRect(
            x: CGFloat(col) * (frameSize.width),
            y: self.atlas.size().height-CGFloat(y)-frameSize.height,
            width: frameSize.width,
            height: frameSize.height)
        
        let normalizedRect = CGRect(
            x: textureRect.origin.x / atlasSize.width,
            y: textureRect.origin.y / atlasSize.height,
            width: frameSize.width / atlasSize.width,
            height: frameSize.height / atlasSize.height
        )

        let texture = SKTexture(rect: normalizedRect, in: atlas)
        texture.filteringMode = .nearest
        return texture
    }
    
    func textureForBorder(row: Int, col: Int) -> SKTexture {
        var borderFrameSize: CGSize {
            return CGSize(
                width: CGFloat(borderRowWidths[row]!),
                height: CGFloat(borderRowHeights[row]!)
            )
        }
        
        let frameSize = borderFrameSize
        let atlasSize = atlas.size()
        var x = 156
        var y = 0
        for i in 0..<row {
            y += borderRowHeights[i]!
        }
        
        x += borderRowWidths[row]!*col
        
        let textureRect = CGRect(
            x: CGFloat(x),
            y: self.atlas.size().height-CGFloat(y)-frameSize.height,
            width: frameSize.width,
            height: frameSize.height)
        
        let normalizedRect = CGRect(
            x: textureRect.origin.x / atlasSize.width,
            y: textureRect.origin.y / atlasSize.height,
            width: frameSize.width / atlasSize.width,
            height: frameSize.height / atlasSize.height
        )

        let texture = SKTexture(rect: normalizedRect, in: atlas)
        texture.filteringMode = .nearest
        return texture
    }
}
