//
//  SpriteSheet.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import Foundation
import SpriteKit

struct SpriteSheet {
    let atlas: SKTexture
    let row: Int
    let columns: Int
    let rowHeights = [0:26, 1:23, 2:23, 3:16]
    let rowWidths = [0:26, 1:13, 2:13, 3:16]

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
}
