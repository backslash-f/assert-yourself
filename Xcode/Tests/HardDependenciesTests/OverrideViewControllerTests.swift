//
//  OverrideViewControllerTests.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 18.08.23.
//

import XCTest

@testable import AssertYourself

class OverrideViewControllerTests: XCTestCase {

    func test_viewDidAppear() {
        let sut = TestableOverrideViewController()
        sut.loadViewIfNeeded()

        sut.viewDidAppear(false)

        // Normally, assert something.
    }
}

private class TestableOverrideViewController: OverrideViewController {
    override func analytics() -> Analytics {
        Analytics()
    }
}
