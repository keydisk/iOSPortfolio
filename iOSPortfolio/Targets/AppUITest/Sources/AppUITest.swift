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

    func checkBlogExistView() {
        let blogListView = app.descendants(matching: .any)["blogListView"]
        XCTAssertTrue(blogListView.waitForExistence(timeout: 2), "blogListView가 존재하지 않습니다.")

        let initialCount = blogListView.descendants(matching: .any).matching(identifier: "blogListCell").count

        // 스크롤을 한 번 실행
        for _ in 0..<3 {
            blogListView.swipeUp()
        }

        // (네트워크/로딩이 필요하다면 잠시 대기)
        sleep(2) // 필요시

        let afterScrollCount = blogListView.descendants(matching: .any).matching(identifier: "blogListCell").count

        XCTAssertTrue(afterScrollCount > initialCount, "페이징 실패")
    }


    //MARK: Video list test
    func checkVideoViewExist() {
        let videoList = app.descendants(matching: .any)["videoList"]

        XCTAssertTrue(videoList.waitForExistence(timeout: 1), "비디오 리스트가 존재하지 않습니다.")

        let initialCount = videoList.descendants(matching: .any).matching(identifier: "blogListCell").count

        // 스크롤을 한 번 실행
        for _ in 0..<3 {
            videoList.swipeUp()
        }

        // (네트워크/로딩이 필요하다면 잠시 대기)
        sleep(2) // 필요시

        let videoCellList = videoList.descendants(matching: .any).matching(identifier: "videoListCell")
        let afterScrollCount = videoCellList.count

        XCTAssertTrue(afterScrollCount > initialCount, "비디오 페이징 실패")

        videoCellList.firstMatch.tap()

        let webView = app.descendants(matching: .any)["testWebView"].firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 2), "웹뷰로 이동하지 않음.")

        let webViewBack = app.descendants(matching: .any)["webViewBack"].firstMatch
        webViewBack.tap()
    }

    // MARK: 전체 테스트
    @MainActor
    func testSearchAndFilterAndViewer() throws {

        print(app.debugDescription)
        //MARK: 초기 뷰 확인
        let initView = app.descendants(matching: .any)["initView"].firstMatch
        XCTAssertTrue(initView.waitForExistence(timeout: 2), "초기 뷰가 없음")


        // MARK: 검색어 입력 필드 접근
        let searchField = app.textFields["상품, 서비스 검색"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 2))

        // MARK: 텍스트 입력
        searchField.tap()
        searchField.typeText("kakao")

        // MARK: 키보드에서 Search 키 선택
        app.keyboards.buttons["search"].tap()

        checkBlogExistView()

        // MARK: blog 첫번째 셀이 존재하는지 확인
        let firstCell = app.descendants(matching: .any)["blogListCell"].firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 2), "첫 번째 블로그 셀이 존재하지 않습니다.")
        firstCell.tap()

        // MARK: 웹뷰로 이동 하는지 확인
        let webView = app.descendants(matching: .any)["testWebView"].firstMatch
        XCTAssertTrue(webView.waitForExistence(timeout: 2), "웹뷰로 이동하지 않음.")

        let webViewBack = app.descendants(matching: .any)["webViewBack"].firstMatch
        webViewBack.tap()

        // MARK: 블로그 리스트로 이동하는지 확인
        let blogListView = app.descendants(matching: .any)["blogListView"]
        XCTAssertTrue(blogListView.waitForExistence(timeout: 2), "blogListView가 존재하지 않습니다.")

        let blogTapBtn = app.descendants(matching: .any)["tap블로그"]
        let imageTapBtn = app.descendants(matching: .any)["tap이미지"]
        let videoTapBtn = app.descendants(matching: .any)["tap비디오"]

        // MARK: 텝 버튼이 정상적으로 나오는지 확인
        XCTAssertTrue(blogTapBtn.waitForExistence(timeout: 1), "blogTap 버튼이 존재하지 않습니다.")
        XCTAssertTrue(imageTapBtn.waitForExistence(timeout: 1), "imageTap 버튼이 존재하지 않습니다.")
        XCTAssertTrue(videoTapBtn.waitForExistence(timeout: 1), "videoTap 버튼이 존재하지 않습니다.")

        // MARK: 이미지 텝으로 이동
        imageTapBtn.tap()
        //MARK: Image 리스트에서 페이징까지 되는지 확인
        var imageList = app.descendants(matching: .any)["imageList"]
        XCTAssertTrue(imageList.waitForExistence(timeout: 1), "이미지 리스트가 존재하지 않습니다.")

        let initialImageCount = imageList.descendants(matching: .any).matching(identifier: "imageCell").count

        // 스크롤을 한 번 실행
        for _ in 0..<3 {
            blogListView.swipeUp()
        }

        sleep(2)

        let afterImageScrollCount = imageList.descendants(matching: .any).matching(identifier: "imageCell").count

        XCTAssertTrue(afterImageScrollCount > initialImageCount, "이미지 페이징 실패")


        let imageCell = app.descendants(matching: .any)["imageCell"].firstMatch
        XCTAssertTrue(imageCell.waitForExistence(timeout: 1), "이미지 셀이 존재하지 않습니다")

        imageCell.tap()

        //MARK: Image 상세보기로 이동하는지 확인

        let imageDetail = app.descendants(matching: .any)["imageDetailView"]
        XCTAssertTrue(imageDetail.waitForExistence(timeout: 1), "이미지 상세보기 존재하지 않습니다")

        //MARK: 뒤로가기 한후 이미지 리스트가 존재하는지 확인
        let imageDetailBack = app.descendants(matching: .any)["imageDetailBack"].firstMatch
        imageDetailBack.tap()

        imageList = app.descendants(matching: .any)["imageList"]
        XCTAssertTrue(imageList.waitForExistence(timeout: 1), "이미지 리스트가 존재하지 않습니다.")

        //MARK: 비디오 리스트에서 페이징과 웹뷰로 이동하는지 까지 되는지 확인 (시뮬레이터에선 유튜브가 정상적으로 나오지 않음)
        videoTapBtn.tap()

        //MARK: - Video List Test
        checkVideoViewExist()

        searchField.tap()
        sleep(1)

        //MARK: 텍스트 필드를 텝하고 전체 지우기 버튼을 텝
        let searchedHistory = app.descendants(matching: .any)["searchedHistory"]
        XCTAssertTrue(searchedHistory.waitForExistence(timeout: 1), "텍스트 필드와 매치된 검색 리스트를 보여주는 리스트가 없습니다.")

        //MARK: 텍스트 필드 전체 지우기 선택
        var deleteBtn = app.descendants(matching: .any)["textfieldCloseCustomButton"]

        XCTAssertTrue(deleteBtn.waitForExistence(timeout: 1), "텍스트 필드에 전체 지우기 버튼이 없습니다.")
        deleteBtn.tap()

        sleep(1)

        //MARK: 최근 히스토리가 정상적으로 나오는지 확인
        let latelyHistoryList = app.descendants(matching: .any)["latelyHistoryList"]
        XCTAssertTrue(latelyHistoryList.waitForExistence(timeout: 1), "최근 검색 히스토리가 없습니다.")

        let latelyHistoryCell = app.descendants(matching: .any)["latelyHistoryCell"]
        XCTAssertTrue(latelyHistoryCell.waitForExistence(timeout: 1), "최근 검색 히스토리 항목이 없습니다.")

        let allHistoryDeleteBtn = app.descendants(matching: .any)["allHistoryDeleteBtn"]
        XCTAssertTrue(allHistoryDeleteBtn.waitForExistence(timeout: 1), "전체 히스토리 삭제 버튼이 없습니다.")

        let LatelySearchElementViewTitle = app.descendants(matching: .any)["LatelySearchElementViewTitle"].firstMatch

        LatelySearchElementViewTitle.tap()
        sleep(1)
        blogTapBtn.tap()
        checkBlogExistView()

        sleep(1)
        searchField.tap()
        sleep(1)

        //MARK: 최근 히스토리 지우기 선택
        deleteBtn = app.descendants(matching: .any)["textfieldCloseCustomButton"]

        XCTAssertTrue(deleteBtn.waitForExistence(timeout: 1), "텍스트 필드에 전체 지우기 버튼이 없습니다.")
        deleteBtn.tap()
        sleep(1)

        allHistoryDeleteBtn.tap()

        //MARK: 최근 검색한 히스토리가 없다는 뷰 확인
        let emptyHistoryView = app.descendants(matching: .any)["emptyHistoryView"]
        XCTAssertTrue(emptyHistoryView.waitForExistence(timeout: 1), "히스토리가 없다는 뷰가 없습니다.")
    }
}
