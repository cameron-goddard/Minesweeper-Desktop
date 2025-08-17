//
//  Binding.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 7/20/25.
//

import Foundation

// TODO: Move
let bindings: [Binding] = [
//    Binding(name: "Chord", tooltipText: "", defaultCharCode: <#T##UInt32?#>, charCode: <#T##UInt32?#>)
]

struct Binding {
    
    let name: String
    let tooltipText: String
    let defaultCharCode: UInt32?
    
    var charCode: UInt32?
    
    init(name: String, tooltipText: String, defaultCharCode: UInt32? = nil, charCode: UInt32? = nil) {
        self.name = name
        self.tooltipText = tooltipText
        self.defaultCharCode = defaultCharCode
        self.charCode = charCode
    }
}
