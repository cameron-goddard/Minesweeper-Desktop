//
//  Errors.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 7/11/25.
//

import Foundation

extension NSError {
    static func invalidBoardError() -> NSError {
        return NSError(
            domain: "Invalid Board File",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "The selected file is not a valid Minesweeper board."]
        )
    }
}
