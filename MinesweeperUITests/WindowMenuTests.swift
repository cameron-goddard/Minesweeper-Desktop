import XCTest

final class WindowMenuTests: MinesweeperUITestCase {

    func testKeepOnTopMenuItemExists() {
        app.menuBars.menuBarItems["Window"].click()
        let item = app.menuItems["Keep on Top"]
        XCTAssertTrue(item.waitForExistence(timeout: 5))
    }

    func testKeepOnTopMenuItemCanBeToggled() {
        openWindowMenuItem("Keep on Top")
        XCTAssertTrue(app.windows["Main"].exists)

        openWindowMenuItem("Keep on Top")
        XCTAssertTrue(app.windows["Main"].exists)
    }
}
