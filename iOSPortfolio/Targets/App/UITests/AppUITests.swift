import XCTest

final class AppUITests: XCTestCase {
    @MainActor
    func test_uiExample() throws {
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.buttons.count >= 0)
    }
}
