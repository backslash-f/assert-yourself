//
//  NetworkResponseTests.swift
//  NetworkResponseTests
//
//  Created by Fernando Fernandes on 26.08.23.
//

import XCTest

@testable import AssertYourself

final class ViewControllerTests: XCTestCase {

    @MainActor
    func test_searchForBookNetworkCall_withSuccessResponse_shouldSaveDataInResults() async {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let sut: ViewController = sb.instantiateViewController(
            identifier: String(describing: ViewController.self)
        )

        let spyURLSession = SpyURLSession(
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
}

// MARK: - Private

private func jsonData() -> Data {
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
