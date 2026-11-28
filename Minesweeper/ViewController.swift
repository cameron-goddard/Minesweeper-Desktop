//
//  ViewController.swift
//  Minesweeper
//
//  Created by Cameron Goddard on 4/3/22.
//

import Cocoa
import Defaults
import GameplayKit
import SpriteKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!

    private var didConfigureScene = false
    private var didSetWindowTitle = false

    var difficulty = Defaults[.Game.difficulty]
    let scale = Defaults[.General.scale]

    var minesLayout: [(Int, Int)]?
    var rows, cols, mines: Int!

    var difficulties = [
        "Beginner": [8, 8, 10],
        "Intermediate": [16, 16, 40],
        "Hard": [16, 30, 99],
        "Custom": [8, 8, 10],
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
            self, selector: #selector(self.setSubtitle(_:)), name: .setSubtitle, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.setScale(_:)), name: .setScale, object: nil)

        ThemeManager.shared.setCurrent(with: Defaults[.Themes.theme])
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        configureSceneIfNeeded()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        configureSceneIfNeeded()

        if !didSetWindowTitle {
            if Defaults[.General.toolbarDifficulty] {
                view.window?.subtitle = difficulty
            } else {
                view.window?.subtitle = ""
            }
            didSetWindowTitle = true
        }

        // Ensure window level matches the persisted preference when the view appears
        if Defaults[.General.keepOnTop] {
            view.window?.level = .floating
        } else {
            view.window?.level = .normal
        }
    }

    @objc func setSubtitle(_: Notification) {
        if Defaults[.General.toolbarDifficulty] {
            view.window!.subtitle = difficulty
        } else {
            view.window!.subtitle = ""
        }
    }

    @objc func setScale(_: Notification) {
        let sceneMetrics = sceneMetrics(forRows: rows, cols: cols, baseScale: Defaults[.General.scale])

        view.setFrameSize(sceneMetrics.size)
        skView.setFrameSize(sceneMetrics.size)

        if let scene = getScene() {
            scene.size = sceneMetrics.size
            scene.updateScale(size: sceneMetrics.size, scale: sceneMetrics.scale)
        }
    }

    private func configureSceneIfNeeded() {
        guard !didConfigureScene else { return }
        guard let skView else { return }

        if let window = view.window {
            view.setFrameSize(window.frame.size)
            skView.setFrameSize(window.frame.size)
        } else if view.bounds.width > 0, view.bounds.height > 0 {
            skView.frame = view.bounds
        }

        guard skView.bounds.width > 0, skView.bounds.height > 0 else { return }

        if difficulty == "Custom" || difficulty == "Loaded Custom" {
            rows = Defaults[.Game.customDifficulty][0]
            cols = Defaults[.Game.customDifficulty][1]
            mines = Defaults[.Game.customDifficulty][2]
        } else {
            rows = difficulties[difficulty]![0]
            cols = difficulties[difficulty]![1]
            mines = difficulties[difficulty]![2]
        }

        rows = max(1, rows)
        cols = max(1, cols)
        mines = max(0, mines)

        let sceneMetrics = sceneMetrics(forRows: rows, cols: cols, baseScale: Defaults[.General.scale])
        view.setFrameSize(sceneMetrics.size)
        skView.setFrameSize(sceneMetrics.size)

        let scene = GameScene(
            size: sceneMetrics.size, scale: sceneMetrics.scale, rows: rows, cols: cols, mines: mines,
            minesLayout: minesLayout)
        skView.presentScene(scene)

        didConfigureScene = true
    }

    private func sceneMetrics(forRows rows: Int, cols: Int, baseScale: CGFloat) -> (size: NSSize, scale: CGFloat) {
        let naturalWidth = baseScale * CGFloat(24 + cols * 16)
        let naturalHeight = baseScale * CGFloat(67 + rows * 16)

        let size = NSSize(width: max(1, naturalWidth), height: max(1, naturalHeight))
        return (size, baseScale)
    }

    func getScene() -> GameScene? {
        return skView.scene as? GameScene
    }

    func getBoard() -> Board? {
        return (skView.scene as? GameScene)?.board
    }
}
