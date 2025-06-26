//
//  ThemeManager.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/24/25.
//

import Foundation
import SpriteKit
import Defaults
import NaturalLanguage

class ThemeManager {
    
    static let shared = ThemeManager()
    
    var current: Theme
    var themes: [Theme]
    
    let defaultThemes: [Theme] = [
        Theme(
            name: "Classic",
            desc: "The original Minesweeper theme",
            isDefault: true,
            isFavorite: Defaults[.Themes.favorites].contains("Classic"),
            spriteSheetTexture: SKTexture(imageNamed: "classic")
        ),
        Theme(
            name: "Classic 95",
            desc: "The default theme from Windows 95",
            isDefault: true,
            isFavorite: Defaults[.Themes.favorites].contains("Classic 95"),
            spriteSheetTexture: SKTexture(imageNamed: "classic_95")
        ),
        Theme(
            name: "Classic Dark",
            desc: "A dark twist on the original theme",
            isDefault: true,
            isFavorite: Defaults[.Themes.favorites].contains("Classic Dark"),
            mode: "Dark",
            spriteSheetTexture: SKTexture(imageNamed: "classic_dark")
        )
    ]
    
    let themesURL: URL = {
        let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return appSupportURL.appendingPathComponent("Minesweeper Desktop/Themes")
    }()
    
    private init() {
        current = defaultThemes.first!
        themes = defaultThemes
    }
    
    func addTheme(fileName: String) throws {
        let themePath = themesURL.appendingPathComponent(fileName)
        
        let name = themePath.deletingPathExtension().lastPathComponent
        let image = NSImage(contentsOf: themePath)!
        image.size = NSSize(width: 144, height: 122) // Account for different DPIs
        
        let theme = Theme(
            name: toTheme(name: name),
            fileName: fileName,
            isFavorite: Defaults[.Themes.favorites].contains(name),
            spriteSheetTexture: SKTexture(image: image)
        )
        themes.append(theme)
    }
    
    func readThemes() throws {
        let themes = try FileManager.default.contentsOfDirectory(atPath: themesURL.path)
        
        for theme in themes {
            if theme == ".DS_Store" { continue }
            let themePath = themesURL.appendingPathComponent(theme)
            
            let name = toTheme(name: themePath.deletingPathExtension().lastPathComponent)
            let fileName = themePath.lastPathComponent
            
            guard let image = NSImage(contentsOf: themePath) else {
                throw NSError(domain: "Invalid Theme", code: 0, userInfo: [
                    NSLocalizedDescriptionKey: "Failed to load theme from file: \(theme)"
                ])
            }
            image.size = NSSize(width: 144, height: 122) // Account for different DPIs
            
            let theme = Theme(
                name: name,
                fileName: fileName,
                isFavorite: Defaults[.Themes.favorites].contains(name),
                spriteSheetTexture: SKTexture(image: image)
            )
            self.themes.append(theme)
        }
        NotificationCenter.default.post(name: .updateFavorites, object: nil)
    }
    
    func theme(with name: String) -> Theme {
        return themes.first(where: { $0.name == name }) ?? themes.first!
    }
    
    func toTheme(name: String) -> String {
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
