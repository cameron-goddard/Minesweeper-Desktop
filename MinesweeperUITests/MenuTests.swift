import XCTest

final class MenuTests: MinesweeperUITestCase {

    private func windowWidthAfterChoosing(_ difficulty: String) -> CGFloat {
        openGameMenuItem(difficulty)
        return mainWindow.frame.width
    }

    func testDifficultyShortcutsResizeWindow() {
        app.typeKey("1", modifierFlags: .command)
        let beginner = mainWindow.frame.width

        app.typeKey("2", modifierFlags: .command)
        let intermediate = mainWindow.frame.width

        app.typeKey("3", modifierFlags: .command)
        let hard = mainWindow.frame.width

        XCTAssertLessThan(beginner, intermediate, "Intermediate should be wider than Beginner")
        XCTAssertLessThan(intermediate, hard, "Hard should be wider than Intermediate")
    }

    func testDifficultyMenuItemsResizeWindow() {
        let hard = windowWidthAfterChoosing("Hard")
        let intermediate = windowWidthAfterChoosing("Intermediate")
        let beginner = windowWidthAfterChoosing("Beginner")

        XCTAssertGreaterThan(hard, intermediate, "Hard should be wider than Intermediate")
        XCTAssertGreaterThan(intermediate, beginner, "Intermediate should be wider than Beginner")
    }
}
