import XCTest

final class CustomGameSheetTests: MinesweeperUITestCase {

    private var rowsField: XCUIElement { app.textFields["Rows"] }
    private var colsField: XCUIElement { app.textFields["Columns"] }

    private func openCustomGameSheet() {
        openGameMenuItem("Custom...")
        XCTAssertTrue(app.sheets.firstMatch.waitForExistence(timeout: 5))
    }

    func testOpenCustomGameSheetShowsExpectedControls() {
        openCustomGameSheet()

        XCTAssertTrue(rowsField.waitForExistence(timeout: 3))
        XCTAssertTrue(colsField.exists)
        XCTAssertTrue(app.sliders.firstMatch.exists)
        XCTAssertTrue(app.buttons["Random"].exists)
        XCTAssertTrue(app.buttons["Cancel"].exists)
        XCTAssertTrue(app.buttons["Generate"].exists)
    }

    func testCancelDismissesSheet() {
        openCustomGameSheet()
        app.buttons["Cancel"].click()

        let dismissed = !app.sheets.firstMatch.waitForExistence(timeout: 3)
            || !app.sheets.firstMatch.exists
        XCTAssertTrue(dismissed)
    }

    func testRandomButtonPopulatesRowsAndColumns() {
        openCustomGameSheet()

        XCTAssertTrue(rowsField.waitForExistence(timeout: 3))
        XCTAssertEqual(rowsField.value as? String, "")
        XCTAssertEqual(colsField.value as? String, "")

        app.buttons["Random"].click()

        let populatedRows = rowsField.value as? String ?? ""
        let populatedCols = colsField.value as? String ?? ""
        XCTAssertFalse(populatedRows.isEmpty)
        XCTAssertFalse(populatedCols.isEmpty)
    }

    func testGenerateWithValidValuesDismissesSheet() {
        openCustomGameSheet()

        XCTAssertTrue(rowsField.waitForExistence(timeout: 3))
        rowsField.click()
        app.typeText("10")

        colsField.click()
        app.typeText("10")

        app.buttons["Generate"].click()

        let dismissed = !app.sheets.firstMatch.waitForExistence(timeout: 3)
            || !app.sheets.firstMatch.exists
        XCTAssertTrue(dismissed)
        XCTAssertTrue(app.windows["Main"].exists)
    }
}
