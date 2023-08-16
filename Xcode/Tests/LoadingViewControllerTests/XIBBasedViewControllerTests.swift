//
//  XIBBasedViewControllerTests.swift
//  AssertYourselfTests
//
//  Created by Fernando Fernandes on 16.08.23.
//

import XCTest

@testable import AssertYourself

final class XIBBasedViewControllerTests: XCTestCase {
    func test_loading() {
        let sut = XIBBasedViewController()
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.label)
    }
}
