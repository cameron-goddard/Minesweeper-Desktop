//
//  Notifications.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/24/25.
//

import Foundation

extension Notification.Name {
    static let appleInterfaceThemeChanged = Notification.Name(
        rawValue: "AppleInterfaceThemeChangedNotification")
    static let restartGame = Notification.Name("RestartGame")
    static let updateStat = Notification.Name("UpdateStats")
    static let resetStats = Notification.Name("ResetStats")
    static let revealStats = Notification.Name("RevealStats")
    static let newCustomGame = Notification.Name("NewCustomGame")
    static let updateFavorites = Notification.Name("UpdateFavorites")
    static let setTheme = Notification.Name("SetTheme")
    static let setSubtitle = Notification.Name("SetSubtitle")
    static let setScale = Notification.Name("SetScale")
}
