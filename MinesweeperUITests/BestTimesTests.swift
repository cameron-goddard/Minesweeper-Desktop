import XCTest

final class BestTimesTests: MinesweeperUITestCase {

    private static let fieldIdentifiers = [
        "bestTimes.beginner.1", "bestTimes.beginner.2", "bestTimes.beginner.3",
        "bestTimes.intermediate.1", "bestTimes.intermediate.2", "bestTimes.intermediate.3",
        "bestTimes.hard.1", "bestTimes.hard.2", "bestTimes.hard.3",
    ]

    private func openBestTimesSheet() {
        openGameMenuItem("Best Times...")
        XCTAssertTrue(app.sheets.firstMatch.waitForExistence(timeout: 5))
    }

    private func bestTimeField(_ id: String) -> XCUIElement {
        let textField = app.textFields[id]
        if textField.exists { return textField }
        return app.staticTexts[id]
    }

    func testBestTimesSheetHasAllNineFields() {
        openBestTimesSheet()

        for id in Self.fieldIdentifiers {
            XCTAssertTrue(bestTimeField(id).exists)
        }
    }

    func testResetScoresSetsAllFieldsToDash() {
        openBestTimesSheet()
        app.buttons["Reset Scores"].click()

        for id in Self.fieldIdentifiers {
            let field = bestTimeField(id)
            let value = field.value as? String ?? field.label
            XCTAssertEqual(value, "-")
        }
    }

    func testOKDismissesSheet() {
        openBestTimesSheet()
        app.buttons["OK"].click()

        let dismissed = !app.sheets.firstMatch.waitForExistence(timeout: 3)
            || !app.sheets.firstMatch.exists
        XCTAssertTrue(dismissed)
    }
}
