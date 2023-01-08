//
//  Util.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 5/30/22.
//

import Foundation
import SpriteKit

class Util {
    static let scale = CGFloat(1.5)
    
    static let monoClassicTheme = Theme(name: "Classic Mono", spriteSheetTexture: SKTexture(imageNamed: "monochrome_spritesheet"), backgroundColor: NSColor(red: 61, green: 61, blue: 61, alpha: 1))
    static let normalClassicTheme = Theme(name: "Classic", desc: "The original Minesweeper theme", spriteSheetTexture: SKTexture(imageNamed: "default_spritesheet"), backgroundColor: NSColor(red: 61, green: 61, blue: 61, alpha: 1))
    static let classic95Theme = Theme(name: "Classic 95", desc: "The default theme from Windows 95", spriteSheetTexture: SKTexture(imageNamed: "default_spritesheet_95"), backgroundColor: NSColor(red: 61, green: 61, blue: 61, alpha: 1))
    static let darkClassicTheme = Theme(name: "Classic Dark", mode: "Dark", spriteSheetTexture: SKTexture(imageNamed: "default_dark_spritesheet"), backgroundColor: NSColor(red: 173, green: 173, blue: 173, alpha: 1))
    static let blueClassicTheme = Theme(name: "Classic Blue", desc: "The original Minesweeper theme", spriteSheetTexture: SKTexture(imageNamed: "default_spritesheet_blue"), backgroundColor: NSColor(red: 256, green: 128, blue: 1, alpha: 0))
    static let testTheme = Theme(name: "Test", spriteSheetTexture: SKTexture(imageNamed: "test_spritesheet"), backgroundColor: NSColor(red: 173, green: 173, blue: 173, alpha: 1))
    
    
    static let defaultThemes = [normalClassicTheme, classic95Theme, darkClassicTheme, monoClassicTheme]
    static var themes = defaultThemes + [testTheme, blueClassicTheme]
    //static var currentTheme = userDefault(withKey: .CurrentTheme)
    static var currentTheme = normalClassicTheme //todo
    //var currentTheme : Theme
    static var difficulties = ["Beginner": [8, 8, 10], "Intermediate": [16, 16, 40], "Hard": [16, 30, 99], "Custom": [8, 8, 1]]
    
    static func convertLocation(name: String) -> Array<Int> {
        let coords = name.components(separatedBy: ",")
        let r = Int(String(coords[0]))!
        let c = Int(String(coords[1]))!
        return [r, c]
    }
    
    static func textureLookup(value: Value) -> SKTexture {
        switch value {
        case .Mine:
            return Util.currentTheme.tiles.mine
        case .MineRed:
            return Util.currentTheme.tiles.mineRed
        case .MineWrong:
            return Util.currentTheme.tiles.mineWrong
        case .One:
            return Util.currentTheme.tiles.one
        case .Two:
            return Util.currentTheme.tiles.two
        case .Three:
            return Util.currentTheme.tiles.three
        case .Four:
            return Util.currentTheme.tiles.four
        case .Five:
            return Util.currentTheme.tiles.five
        case .Six:
            return Util.currentTheme.tiles.six
        case .Seven:
            return Util.currentTheme.tiles.seven
        case .Eight:
            return Util.currentTheme.tiles.eight
        default:
            return Util.currentTheme.tiles.empty
        }
    }
    
    static func theme(withName: String) -> Theme {
        for theme in themes {
            if theme.name == withName {
                return theme
            }
        }
        return themes[0]
    }
    
    static func userDefault(withKey: UserDefaultsKey) -> Any {
        switch withKey {
        case .CurrentDifficulty:
            if let currentDifficulty = UserDefaults.standard.object(forKey: "currentDifficulty") as? String {
                return currentDifficulty
            }
        case .CurrentTheme:
            if let currentTheme = UserDefaults.standard.object(forKey: "currentTheme") as? String {
                return currentTheme
            }
        case .ToolbarDifficulty:
            if let showDifficulty = UserDefaults.standard.object(forKey: "toolbarDifficulty") as? Int {
                return showDifficulty == 1
            }
        case .Appearance:
            return "Classic"
        case .Style:
            return "Classic"
        case .SafeFirstClick:
            if let safeFirstClick = UserDefaults.standard.object(forKey: "safeFirstClick") as? Int {
                return safeFirstClick == 1
            }
        case .UseQuestions:
            if let useQuestions = UserDefaults.standard.object(forKey: "useQuestions") as? Int {
                return useQuestions == 1
            }
        }
        return true
    }
    
    static func setUserDefault(forKey: UserDefaultsKey, sender: Any) {
        switch forKey {
        case .CurrentDifficulty:
            UserDefaults.standard.set(sender as! String, forKey: forKey.rawValue)
        case .CurrentTheme:
            UserDefaults.standard.set(sender as! String, forKey: forKey.rawValue)
        case .ToolbarDifficulty:
            UserDefaults.standard.set((sender as! NSButton).state.rawValue, forKey: forKey.rawValue)
        case .Appearance: break
            
        case .Style: break
            
        case .SafeFirstClick: 
            UserDefaults.standard.set((sender as! NSButton).state.rawValue, forKey: forKey.rawValue)
        case .UseQuestions:
            UserDefaults.standard.set((sender as! NSButton).state.rawValue, forKey: forKey.rawValue)
        }
    }
    
    
}

enum UserDefaultsKey: String {
    case CurrentDifficulty = "currentDifficulty"
    case CurrentTheme = "currentTheme"
    case ToolbarDifficulty = "toolbarDifficulty"
    case Appearance = "appearance"
    case Style = "style"
    case SafeFirstClick = "safeFirstClick"
    case UseQuestions = "useQuestions"
}
