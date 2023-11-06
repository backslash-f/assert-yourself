//
//  TextFieldTests.swift
//  TextFieldTests
//
//  Created by Fernando Fernandes on 06.11.23.
//

import XCTest

@testable import AssertYourself

final class TextFieldTests: XCTestCase {

    private var sut: ViewController!

    @MainActor
    override func setUp() {
        super.setUp()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: ViewController.self)
        sut = sb.instantiateViewController(identifier: identifier)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_outlets_shouldBeConnected() throws {
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.usernameField, "usernameField")
        XCTAssertNotNil(sut.passwordField, "passwordField")
    }
}
