import XCTest

final class StatsAndToolbarTests: MinesweeperUITestCase {

    func testShowStatsShortcutOpensStatsPanel() {
        XCTAssertFalse(app.tables["stats.table"].exists)

        app.typeKey("s", modifierFlags: [.command, .shift])

        XCTAssertTrue(app.tables["stats.table"].waitForExistence(timeout: 5))
        
        let timerExists = app.textFields["stats.timer"].exists
            || app.staticTexts["stats.timer"].exists
        XCTAssertTrue(timerExists)
    }

    func testShowStatsTogglesPanelOff() {
        app.typeKey("s", modifierFlags: [.command, .shift])
        let table = app.tables["stats.table"]
        XCTAssertTrue(table.waitForExistence(timeout: 5))

        app.typeKey("s", modifierFlags: [.command, .shift])

        let deadline = Date().addingTimeInterval(5)
        while table.exists && Date() < deadline {
            usleep(100_000)
        }
        XCTAssertFalse(table.exists)
    }

    func testStatsPanelHasSixRows() {
        app.typeKey("s", modifierFlags: [.command, .shift])
        let table = app.tables["stats.table"]
        XCTAssertTrue(table.waitForExistence(timeout: 5))
        XCTAssertEqual(table.tableRows.count, 6)
    }

    func testThemesToolbarItemExists() {
        XCTAssertTrue(
            app.toolbars.firstMatch.waitForExistence(timeout: 5)
        )
        XCTAssertTrue(
            app.toolbars.buttons["Themes"].exists
                || app.toolbars.descendants(matching: .any)["Themes"].exists
        )
    }

    func testStatsToolbarItemExists() {
        XCTAssertTrue(app.toolbars.firstMatch.waitForExistence(timeout: 5))
        XCTAssertTrue(
            app.toolbars.buttons["Stats"].exists
                || app.toolbars.descendants(matching: .any)["Stats"].exists
        )
    }
}
