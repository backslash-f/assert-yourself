//
//  OutletConnectionTests.swift
//  OutletConnectionTests
//
//  Created by Fernando Fernandes on 21.08.23.
//

import XCTest

@testable import AssertYourself

final class OutletConnectionTests: XCTestCase {

    func test_outlets_shouldBeConnected() {
        let sut = OutletConnectionsViewController()

        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.label, "label")
        XCTAssertNotNil(sut.button, "button")
    }
}
