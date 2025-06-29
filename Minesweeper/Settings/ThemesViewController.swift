//
//  ThemesViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 6/19/22.
//

import Cocoa
import Defaults
import GameplayKit
import UniformTypeIdentifiers

class ThemesViewController: NSViewController {

    @IBOutlet weak var tableView: NSTableView!
    var themes: [Theme] = ThemeManager.shared.themes

    @IBOutlet weak var themePreview: SKView!
    @IBOutlet weak var themeName: NSTextField!
    @IBOutlet weak var themeDesc: NSTextField!
    @IBOutlet weak var addDeleteControl: NSSegmentedControl!

    var scenePreview: GameScene!
    let previewMinesLayout = [
        (0, 0), (0, 1), (2, 0), (1, 5), (0, 4), (5, 5), (5, 7), (7, 6), (5, 1), (7, 1),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
        tableView.doubleAction = #selector(setThemeButtonPressed(_:))

        scenePreview = GameScene(
            size: CGSize(width: themePreview.frame.width, height: themePreview.frame.height),
            scale: 1.5,
            rows: 8,
            cols: 8,
            mines: 10,
            minesLayout: previewMinesLayout,
            isThemePreview: true
        )
        themePreview.presentScene(scenePreview)

        showThemeInfo()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "Themes"
    }

    func showThemeInfo() {
        let theme = themes[tableView.selectedRow]

        themeName.stringValue = theme.name
        themeDesc.stringValue = theme.desc

        scenePreview.updateTextures(to: theme)

        if theme.isDefault {
            addDeleteControl.setEnabled(false, forSegment: 1)
        } else {
            addDeleteControl.setEnabled(true, forSegment: 1)
        }
    }

    @IBAction func addDeleteControlPressed(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            let openPanel = NSOpenPanel()
            openPanel.allowedContentTypes = [
                UTType(filenameExtension: "bmp")!,
                UTType(filenameExtension: "png")!,
                UTType(filenameExtension: "jpg")!,
                UTType(filenameExtension: "jpeg")!,
            ]

            openPanel.beginSheetModal(
                for: self.view.window!,
                completionHandler: { num in
                    if num == .OK {
                        let path = openPanel.url
                        let file = NSData(contentsOf: path!)
                        do {
                            let themeURL = ThemeManager.shared.themesURL.appendingPathComponent(
                                (path?.absoluteString as! NSString).lastPathComponent)
                            try file!.write(to: themeURL)

                            let fileName = themeURL.lastPathComponent

                            if !ThemeManager.shared.themes.contains(where: { $0.fileName == fileName }) {
                                try ThemeManager.shared.addTheme(fileName: fileName)
                            } else {
                                let alert = NSAlert()
                                alert.messageText = "Duplicate theme"
                                alert.informativeText = "A theme with this name already exists!"
                                alert.runModal()
                            }
                            // tableView.reloadData() messes up the favorite buttons - possibly investigate
                            self.themes = ThemeManager.shared.themes
                            self.tableView.insertRows(
                                at: IndexSet(integer: ThemeManager.shared.themes.count - 1))
                        } catch {
                            print("could not write to file")
                        }
                    } else {
                        print("nothing chosen")
                    }
                })
        } else {
            do {
                let name = themes[tableView.selectedRow].fileName
                let fileURL = ThemeManager.shared.themesURL.appendingPathComponent(name)
                try FileManager.default.removeItem(atPath: fileURL.path)

                let oldRow = tableView.selectedRow
                // TODO: Investigate this bug: Delete a favorited item, add any other back in
                ThemeManager.shared.themes.remove(
                    at: ThemeManager.shared.themes.firstIndex(of: themes[oldRow])!)
                if let index = Defaults[.Themes.favorites].firstIndex(of: themes[oldRow].name) {
                    Defaults[.Themes.favorites].remove(at: index)
                }
                themes.remove(at: themes.firstIndex(of: themes[oldRow])!)
                NotificationCenter.default.post(name: .updateFavorites, object: nil)
                // This shouldn't be an issue since there are non-removable default themes, but be wary of this
                tableView.selectRowIndexes([oldRow - 1], byExtendingSelection: false)
                tableView.removeRows(at: IndexSet(integer: oldRow))
            } catch {
                print("could not delete file")
            }
        }
    }

    @IBAction func setThemeButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: .setTheme, object: themes[tableView.selectedRow].name)
    }
}

extension ThemesViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        if tableView == self.tableView {
            return themes.count
        } else {
            return 36
        }
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard
            let themeCell = tableView.makeView(
                withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "themeCell"), owner: self)
                as? ThemeCellView
        else { return nil }
        themeCell.themeName.stringValue = themes[row].name

        if themes[row].isFavorite {
            themeCell.setFavorite()
        }

        return themeCell
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 20
    }
}

extension ThemesViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        showThemeInfo()
    }
}
