import XCTest

final class BestTimesTests: MinesweeperUITestCase {

    private var sheet: XCUIElement { app.sheets.firstMatch }

    private func openBestTimesSheet() {
        openGameMenuItem("Best Times...")
        XCTAssertTrue(sheet.waitForExistence(timeout: 5), "Best Times sheet did not appear")
    }

    private func bestTimeField(_ id: String) -> XCUIElement {
        sheet.descendants(matching: .any)[id]
    }

    func testResetScoresSetsAllFieldsToDash() {
        openBestTimesSheet()
        sheet.buttons["Reset Scores"].click()

        for id in AccessibilityID.BestTimes.all {
            XCTAssertEqual(bestTimeField(id).value as? String, "-", "Field '\(id)' was not reset")
        }
    }

    func testOKDismissesSheet() {
        openBestTimesSheet()
        sheet.buttons["OK"].click()

        waitForDisappearance(of: sheet)
    }
}
