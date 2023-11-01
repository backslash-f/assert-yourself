//
//  LoadingViewControllerTests.swift
//  LoadingViewControllerTests
//
//  Created by Fernando Fernandes on 16.08.23.
//

import XCTest

@testable import AssertYourself

final class LoadingViewControllerTests: XCTestCase {
    func test_loading() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let sut: StoryboardBasedViewController = sb.instantiateViewController(
            identifier: String(describing: StoryboardBasedViewController.self)
        )
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.label)
    }
}
