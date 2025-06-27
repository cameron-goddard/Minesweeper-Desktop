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

    func textureAt(x: Int, y: Int, w: Int, h: Int) -> SKTexture {
        let atlasSize = atlas.size()
        
        let textureRect = CGRect(
            x: x,
            y: y,
            width: w,
            height: h
        )
        
        let normalizedRect = CGRect(
            x: textureRect.origin.x / atlasSize.width,
            y: textureRect.origin.y / atlasSize.height,
            width: CGFloat(w) / atlasSize.width,
            height: CGFloat(h) / atlasSize.height
        )
        let texture = SKTexture(rect: normalizedRect, in: atlas)
        texture.filteringMode = .nearest
        return texture
    }
}
