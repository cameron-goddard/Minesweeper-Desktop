import XCTest

final class CustomGameSheetTests: MinesweeperUITestCase {

    private var sheet: XCUIElement { app.sheets.firstMatch }
    private var rowsField: XCUIElement { sheet.textFields[AccessibilityID.CustomGame.rows] }
    private var columnsField: XCUIElement { sheet.textFields[AccessibilityID.CustomGame.columns] }

    private func openCustomGameSheet() {
        openGameMenuItem("Custom...")
        XCTAssertTrue(sheet.waitForExistence(timeout: 5), "Custom game sheet did not appear")
    }

    func testMinesSliderUpdatesDifficultyLabel() {
        openCustomGameSheet()
        rowsField.click()
        rowsField.typeText("10")
        columnsField.click()
        columnsField.typeText("10")

        let slider = sheet.sliders.firstMatch

        slider.adjust(toNormalizedSliderPosition: 0)
        XCTAssertTrue(sheet.staticTexts["Difficulty: Easy"].waitForExistence(timeout: 3), "Expected Easy with no mines")

        slider.adjust(toNormalizedSliderPosition: 0.5)
        XCTAssertTrue(sheet.staticTexts["Difficulty: Hard"].waitForExistence(timeout: 3), "Expected Hard with half the tiles mined")
    }

    func testCancelDismissesSheet() {
        openCustomGameSheet()
        sheet.buttons["Cancel"].click()

        waitForDisappearance(of: sheet)
    }

    func testRandomButtonPopulatesRowsAndColumns() {
        openCustomGameSheet()

        XCTAssertEqual(rowsField.value as? String, "")
        XCTAssertEqual(columnsField.value as? String, "")

        sheet.buttons["Random"].click()

        XCTAssertFalse((rowsField.value as? String ?? "").isEmpty, "Rows not populated")
        XCTAssertFalse((columnsField.value as? String ?? "").isEmpty, "Columns not populated")
    }

    func testGenerateResizesWindowToCustomBoard() {
        let originalSize = mainWindow.frame.size
        openCustomGameSheet()

        rowsField.click()
        rowsField.typeText("20")
        columnsField.click()
        columnsField.typeText("30")
        sheet.buttons["Generate"].click()

        waitForDisappearance(of: sheet)
        let newSize = mainWindow.frame.size
        XCTAssertGreaterThan(newSize.width, originalSize.width, "Window should widen for a 30 column board")
        XCTAssertGreaterThan(newSize.height, originalSize.height, "Window should grow taller for a 20 row board")
    }
}
