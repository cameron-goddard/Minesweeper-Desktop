import XCTest

@MainActor
class MinesweeperUITestCase: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-SUEnableAutomaticChecks", "0"]
        app.launch()

        XCTAssertTrue(
            app.windows["Main"].waitForExistence(timeout: 10),
            "Main window did not appear"
        )
    }

    override func tearDownWithError() throws {
        app?.terminate()
    }

    func openGameMenuItem(_ title: String) {
        app.menuBars.menuBarItems["Game"].click()
        let item = app.menuItems[title]
        XCTAssertTrue(item.waitForExistence(timeout: 5), "Menu item '\(title)' not found")
        item.click()
    }

    func openViewMenuItem(_ title: String) {
        app.menuBars.menuBarItems["View"].click()
        let item = app.menuItems[title]
        XCTAssertTrue(item.waitForExistence(timeout: 5), "Menu item '\(title)' not found")
        item.click()
    }

    func openWindowMenuItem(_ title: String) {
        app.menuBars.menuBarItems["Window"].click()
        let item = app.menuItems[title]
        XCTAssertTrue(item.waitForExistence(timeout: 5), "Menu item '\(title)' not found")
        item.click()
    }
}
