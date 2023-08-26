//
//  ViewControllerTests.swift
//  ViewControllerTests
//
//  Created by Fernando Fernandes on 22.08.23.
//

import XCTest

@testable import AssertYourself

final class ViewControllerTests: XCTestCase {

    @MainActor
    func test_shouldSearchForEbookOutFromBoneville() async {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let sut: ViewController = sb.instantiateViewController(
            identifier: String(describing: ViewController.self)
        )

        let mockURLSession = MockURLSession()
        sut.session = mockURLSession
        sut.loadViewIfNeeded()

        await sut.searchForBook(terms: sut.hardcodedSearchTerm)

        let url = URL(string: "https://itunes.apple.com/search?media=ebook&term=out%20from%20boneville")!
        mockURLSession.verifyDataTask(with: URLRequest(url: url))
    }
}
