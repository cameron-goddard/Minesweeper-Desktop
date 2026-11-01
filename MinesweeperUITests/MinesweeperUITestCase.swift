import XCTest

/// Accessibility identifiers shared by UI tests.
enum AccessibilityID {
    static let mainWindow = "Main"

    enum Stats {
        static let table = "stats.table"
        static let timer = "stats.timer"
    }

    enum CustomGame {
        static let rows = "customGame.rows"
        static let columns = "customGame.columns"
    }

    enum BestTimes {
        static let all = ["beginner", "intermediate", "hard"].flatMap { difficulty in
            (1...3).map { "bestTimes.\(difficulty).\($0)" }
        }
    }
}

@MainActor
class MinesweeperUITestCase: XCTestCase {
    let app = XCUIApplication()

    var mainWindow: XCUIElement { app.windows[AccessibilityID.mainWindow] }

    override func setUp() async throws {
        continueAfterFailure = false
        // Pin saved settings so tests start from the same state regardless of earlier runs.
        app.launchArguments += ["-SUEnableAutomaticChecks", "0", "-difficulty", "Beginner"]
        app.launch()

        XCTAssertTrue(
            mainWindow.waitForExistence(timeout: 10),
            "Main window did not appear"
        )
    }

    /// Clicks `title` in the menu bar menu named `menu`.
    func openMenuItem(_ title: String, in menu: String) {
        app.menuBars.menuBarItems[menu].click()
        let item = app.menuItems[title]
        XCTAssertTrue(item.waitForExistence(timeout: 5), "Menu item '\(title)' not found in \(menu)")
        item.click()
    }

    func openGameMenuItem(_ title: String) {
        openMenuItem(title, in: "Game")
    }

    /// Waits for `element` to stop existing, failing the test if it doesn't.
    func waitForDisappearance(
        of element: XCUIElement,
        timeout: TimeInterval = 5,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let expectation = XCTNSPredicateExpectation(
            predicate: NSPredicate(format: "exists == false"),
            object: element
        )
        XCTAssertEqual(
            XCTWaiter().wait(for: [expectation], timeout: timeout),
            .completed,
            "\(element) still exists after \(timeout)s",
            file: file,
            line: line
        )
    }
}
