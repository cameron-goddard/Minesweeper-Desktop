import XCTest

final class StatsAndToolbarTests: MinesweeperUITestCase {

    private static let expectedStatsRowCount = 6

    private var statsTable: XCUIElement { app.tables[AccessibilityID.Stats.table] }

    private func toggleStats() {
        app.typeKey("s", modifierFlags: [.command, .shift])
    }

    func testShowStatsShortcutTogglesStatsPanel() {
        XCTAssertFalse(statsTable.exists, "Stats panel should start hidden")

        toggleStats()

        XCTAssertTrue(statsTable.waitForExistence(timeout: 5), "Stats table did not appear")
        XCTAssertEqual(statsTable.tableRows.count, Self.expectedStatsRowCount)
        XCTAssertTrue(
            app.descendants(matching: .any)[AccessibilityID.Stats.timer].exists,
            "Stats timer missing"
        )

        toggleStats()

        waitForDisappearance(of: statsTable)
    }

    func testToolbarHasThemesAndStatsItems() {
        // The Beginner window is narrow enough to push toolbar items into the overflow menu.
        app.typeKey("3", modifierFlags: .command)

        let toolbar = app.toolbars.firstMatch
        XCTAssertTrue(toolbar.waitForExistence(timeout: 5), "Toolbar missing")

        for title in ["Themes", "Stats"] {
            XCTAssertTrue(toolbar.descendants(matching: .any)[title].exists, "Toolbar item '\(title)' missing")
        }
    }
}
