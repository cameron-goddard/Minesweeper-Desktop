//
//  Util.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 5/30/22.
//

import Foundation
import SpriteKit
import NaturalLanguage
import Defaults

class Util {
    static let scale = CGFloat(1.5)
    
    // TODO: Consider moving these default themes to be actual files
    static let normalClassicTheme = Theme(
        name: "Classic",
        desc: "The original Minesweeper theme",
        isDefault: true,
        isFavorite: Defaults[.favorites].contains("Classic"),
        spriteSheetTexture: SKTexture(imageNamed: "classic")
    )
    static let classic95Theme = Theme(
        name: "Classic 95",
        desc: "The default theme from Windows 95",
        isDefault: true,
        isFavorite: Defaults[.favorites].contains("Classic 95"),
        spriteSheetTexture: SKTexture(imageNamed: "classic_95")
    )
    static let darkClassicTheme = Theme(
        name: "Classic Dark",
        desc: "A dark twist on the original theme",
        isDefault: true,
        isFavorite: Defaults[.favorites].contains("Classic Dark"),
        mode: "Dark",
        spriteSheetTexture: SKTexture(imageNamed: "classic_dark")
    )
    
    static let defaultThemes = [normalClassicTheme, darkClassicTheme, classic95Theme]
    static var themes = defaultThemes
    static var currentTheme = normalClassicTheme
    
    static let themesURL: URL = {
        let fileManager = FileManager.default
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let msSupportURL = appSupportURL.appendingPathComponent("Minesweeper Desktop")
        let themesPath = msSupportURL.appendingPathComponent("Themes")
        return themesPath
    }()
    
    static var difficulties = [
        "Beginner": [8, 8, 10],
        "Intermediate": [16, 16, 40],
        "Hard": [16, 30, 99],
        "Custom": [8, 8, 10]
    ]
    
    static func addTheme(fileName: String) throws {
        let themePath = themesURL.appendingPathComponent(fileName)
        
        let name = themePath.deletingPathExtension().lastPathComponent
        let image = NSImage(contentsOf: themePath)!
        image.size = NSSize(width: 144, height: 122) // Account for different DPIs
        
        let theme = Theme(
            name: Util.toTheme(name: name),
            fileName: fileName,
            isFavorite: Defaults[.favorites].contains(name),
            spriteSheetTexture: SKTexture(image: image)
        )
        Util.themes.append(theme)
    }
    
    static func readThemes() throws {
        let themes = try FileManager.default.contentsOfDirectory(atPath: themesURL.path)
        
        for theme in themes {
            if theme == ".DS_Store" { continue }
            
            let themePath = themesURL.appendingPathComponent(theme)
            
            let name = themePath.deletingPathExtension().lastPathComponent
            let fileName = themePath.lastPathComponent
            
            let image = NSImage(contentsOf: themePath)!
            image.size = NSSize(width: 144, height: 122) // Account for different DPIs
            
            let theme = Theme(
                name: toTheme(name: name),
                fileName: fileName,
                isFavorite: Defaults[.favorites].contains(name),
                spriteSheetTexture: SKTexture(image: image)
            )
            Util.themes.append(theme)
        }
        NotificationCenter.default.post(name: Notification.Name("UpdateThemeMenu"), object: nil)
    }
    
    // make nonstatic
    static func theme(withName: String) -> Theme {
        for theme in themes {
            if theme.name == withName {
                return theme
            }
        }
        return themes[0]
    }
    
    static func toTheme(name: String) -> String {
        let spaced = name.components(separatedBy: "_").joined(separator: " ")
        
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = spaced
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace]
        
        var ret = [String]()
        
        tagger.enumerateTags(in: spaced.startIndex..<spaced.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
            if let tag {
                if tag == .preposition {
                    ret.append("\(spaced[tokenRange])")
                } else {
                    ret.append("\(spaced[tokenRange])".capitalized)
                }
            }
            return true
        }
        return ret.joined(separator: " ")
    }
}

extension Defaults.Keys {
    static let favorites = Key<Array<String>>("favorites", default: ["Classic", "Classic Dark", "Classic 95"])
}
