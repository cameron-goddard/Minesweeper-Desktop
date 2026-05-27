import XCTest

final class MenuTests: MinesweeperUITestCase {

    func testAppLaunchesWithMainWindow() {
        XCTAssertTrue(app.windows["Main"].exists)
    }

    func testNewGameShortcut() {
        app.typeKey("n", modifierFlags: .command)
        XCTAssertTrue(app.windows["Main"].exists)
    }

    func testRestartGameShortcut() {
        app.typeKey("r", modifierFlags: .command)
        XCTAssertTrue(app.windows["Main"].exists)
    }

    func testBeginnerDifficultyShortcut() {
        app.typeKey("1", modifierFlags: .command)
        XCTAssertTrue(app.windows["Main"].exists)
    }

    func testIntermediateDifficultyShortcut() {
        app.typeKey("2", modifierFlags: .command)
        XCTAssertTrue(app.windows["Main"].exists)
    }

    func testHardDifficultyShortcut() {
        app.typeKey("3", modifierFlags: .command)
        XCTAssertTrue(app.windows["Main"].exists)
    }

    func testGameMenuHasExpectedItems() {
        app.menuBars.menuBarItems["Game"].click()
        XCTAssertTrue(app.menuItems["New Game"].exists)
        XCTAssertTrue(app.menuItems["Restart Game"].exists)
        XCTAssertTrue(app.menuItems["Beginner"].exists)
        XCTAssertTrue(app.menuItems["Intermediate"].exists)
        XCTAssertTrue(app.menuItems["Hard"].exists)
        XCTAssertTrue(app.menuItems["Custom..."].exists)
        XCTAssertTrue(app.menuItems["Best Times..."].exists)
    }
}
