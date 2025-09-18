//
//  AppUITestSource.swift
//
//  Tuist 인식을 위한 더미 파일입니다.
//
import XCTest
import App


final class AppUITests: XCTestCase {

    private var app: XCUIApplication!

    override
    func setUp() async throws {
        app = await XCUIApplication()
        await app.launch()
    }

    /// 책 검색
    func bookSearchViewTest() {

        let searchTextField = app.textFields["bookSearchTextField"]
        XCTAssertTrue(searchTextField.waitForExistence(timeout: 2), "책 검색 텍스트 필드가 존재해야 합니다.")
        searchTextField.tap()
        searchTextField.typeText("test")

        let bookListView = app.descendants(matching: .any)["bookListView"]
        XCTAssertTrue(bookListView.waitForExistence(timeout: 2), "bookListView가 존재하지 않습니다.")

        let initialCount = bookListView.descendants(matching: .any).matching(identifier: "bookListCell").count

        for _ in 0..<3 {
            bookListView.swipeUp()
        }

        if app.keyboards.firstMatch.exists {
            app.buttons["Return"].tap()
        }

        sleep(1)

        let bookCellList = bookListView.descendants(matching: .any).matching(identifier: "bookListCell")

        print("afterScrollCount : \(bookCellList.count) initialCount : \(initialCount)")
        XCTAssertTrue(bookCellList.count > initialCount, "페이징 실패")

        // 2. 셀이 화면에 나타날 때까지 기다립니다.
        XCTAssertTrue(bookCellList.firstMatch.waitForExistence(timeout: 5), "첫 번째 셀이 5초 안에 나타나야 합니다.")
        XCTAssertTrue(bookCellList.firstMatch.isHittable, "셀은 탭이 가능한 상태여야 합니다.")

        bookCellList.firstMatch.tap()

        let webView = app.descendants(matching: .any)["testWebView"].firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 2), "웹뷰로 이동하지 않음.")

        let webViewBack = app.descendants(matching: .any)["webViewBack"].firstMatch
        webViewBack.tap()
    }

    //MARK: Image list test
    func imageSearchViewTest() {
        let textfield = app.descendants(matching: .textField)["imageSearchTextField"]
        textfield.tap()
        textfield.typeText("test")

        let imageList = app.descendants(matching: .any)["imageList"]

        XCTAssertTrue(imageList.waitForExistence(timeout: 1), "이미지 리스트가 존재하지 않습니다.")

        let initialCount = imageList.descendants(matching: .any).matching(identifier: "imageSearchThumbnail").count

        if app.keyboards.firstMatch.exists {
            app.buttons["Return"].tap()
        }

        sleep(1)
//
        for _ in 0..<10 {
            imageList.swipeUp(velocity: .fast)
        }

        let imageCell = imageList.descendants(matching: .any).matching(identifier: "imageSearchThumbnail")
        let afterScrollCount = imageCell.count

        XCTAssertTrue(afterScrollCount > initialCount, "이미지 리스트 페이징 실패")

        XCTAssertTrue(imageCell.firstMatch.waitForExistence(timeout: 5), "첫 번째 셀이 5초 안에 나타나야 합니다.")
    }

    //MARK: 북마크 list test
    func bookMarkViewTest() {
        let bookMarkList = app.descendants(matching: .any)["BookMarkViewList"]

        XCTAssertTrue(bookMarkList.waitForExistence(timeout: 1), "북마크 리스트가 존재하지 않습니다.")

        let bookMarkCellList = bookMarkList.descendants(matching: .any).matching(identifier: "bookMarkCell")

        bookMarkCellList.firstMatch.tap()

        let webView = app.descendants(matching: .any)["bookMarkWebView"].firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 2), "북마크 웹뷰로 이동하지 않음.")

        let webViewBack = app.descendants(matching: .any)["bookMarkDetailBackButton"].firstMatch
        XCTAssertTrue(webViewBack.waitForExistence(timeout: 1), "뒤로가기 버튼 부재")
        webViewBack.tap()
    }

    // MARK: 전체 테스트
    @MainActor
    func testView() throws {

//        print("--- UI 계층 구조 디버그 정보 ---")
//        print(app.debugDescription)
//        print("------------------------------")

        bookSearchViewTest()
        sleep(1)
        let imageScreen = app.tabBars.buttons["이미지"]

        imageScreen.firstMatch.tap()
        imageSearchViewTest()

        let bookMarkScreen = app.tabBars.buttons["북마크"]
        bookMarkScreen.tap()
        bookMarkViewTest()
    }
}
