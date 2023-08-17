//
//  MySingletonViewControllerTests.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 17.08.23.
//

import XCTest

@testable import AssertYourself

class MySingletonViewControllerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        MySingletonAnalytics.stubbedInstance = MySingletonAnalytics()
    }

    override func tearDown() {
        MySingletonAnalytics.stubbedInstance = nil
        super.tearDown()
    }

    func test_viewDidAppear() {
        let sut = MySingletonViewController()
        sut.loadViewIfNeeded()

        sut.viewDidAppear(false)

        // Normally, assert something
    }
}
