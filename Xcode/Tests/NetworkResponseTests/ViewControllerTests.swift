//
//  NetworkResponseTests.swift
//  NetworkResponseTests
//
//  Created by Fernando Fernandes on 26.08.23.
//

import ViewControllerPresentationSpy
import XCTest

@testable import AssertYourself

final class ViewControllerTests: XCTestCase {

    private var alertVerifier: AlertVerifier!
    private var sut: ViewController!
    private var spyURLSession: SpyURLSession!

    @MainActor
    override func setUp() {
        super.setUp()
        alertVerifier = AlertVerifier()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        sut = sb.instantiateViewController(
            identifier: String(describing: ViewController.self)
        )
    }

    override func tearDown() {
        alertVerifier = nil
        sut = nil
        spyURLSession = nil
        super.tearDown()
    }

    @MainActor
    func test_searchForBookNetworkCall_withSuccessResponse_shouldSaveDataInResults() async {
        spyURLSession = SpyURLSession(
            data: jsonData(),
            responseStatusCode: 200
        )

        sut.session = spyURLSession
        sut.loadViewIfNeeded()

        await sut.searchForBook(terms: sut.hardcodedSearchTerm)

        XCTAssertEqual(sut.results, [
            SearchResult(
                artistName: "Artist",
                trackName: "Track",
                averageUserRating: 2.5,
                genres: ["Foo", "Bar"]
            )
        ])
    }

    @MainActor
    func test_searchForBookNetworkCall_withError_shouldShowAlert() async {
        let errorMessage = "oh no"
        let error = TestError(message: errorMessage)
        spyURLSession = SpyURLSession(error: error)

        sut.session = spyURLSession
        sut.loadViewIfNeeded()

        let alertShownExpectation = expectation(description: "alert shown")
        alertVerifier.testCompletion = {
            alertShownExpectation.fulfill()
        }

        await sut.searchForBook(terms: sut.hardcodedSearchTerm)

        await fulfillment(of: [alertShownExpectation], timeout: 0.05)
        verifyErrorAlert(message: errorMessage)
    }
}

// MARK: - Private

private extension ViewControllerTests {

    @MainActor
    func verifyErrorAlert(message: String,
                          file: StaticString = #file,
                          line: UInt = #line) {

        alertVerifier.verify(title: "Network problem",
                             message: message,
                             animated: true,
                             actions: [
                                .default("OK")
                             ],
                             presentingViewController: sut,
                             file: file,
                             line: line)

        XCTAssertEqual(alertVerifier.preferredAction?.title, "OK",
                       "preferred action",
                       file: file,
                       line: line)
    }

    func jsonData() -> Data {
        """
        {
            "results":
            [
                {
                    "artistName": "Artist",
                    "trackName": "Track",
                    "averageUserRating": 2.5,
                    "genres":
                    [
                        "Foo",
                        "Bar"
                    ]
                }
            ]
        }
        """.data(using: .utf8)!
    }
}
