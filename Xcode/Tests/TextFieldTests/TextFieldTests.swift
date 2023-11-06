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
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        executeRunLoop()
        sut = nil
        super.tearDown()
    }

    func test_outlets_shouldBeConnected() throws {
        XCTAssertNotNil(sut.usernameField, "usernameField")
        XCTAssertNotNil(sut.passwordField, "passwordField")
    }

    func test_usernameField_attributesShouldBeSet() throws {
        guard let textField = sut.usernameField else {
            XCTFail("Expected username field, got nil")
            return
        }
        XCTAssertEqual(textField.textContentType, .username, "textContentType")
        XCTAssertEqual(textField.autocorrectionType, .no, "autocorrectionType")
        XCTAssertEqual(textField.returnKeyType, .next, "returnKeyType")
    }

    func test_passwordField_attributesShouldBeSet() {
        let textField = sut.passwordField!
        XCTAssertEqual(textField.textContentType, .password, "textContentType")
        XCTAssertEqual(textField.returnKeyType, .go, "returnKeyType")
        XCTAssertTrue(textField.isSecureTextEntry, "isSecureTextEntry")
    }

    func test_textFieldDelegates_shouldBeConnected() {
        XCTAssertNotNil(sut.usernameField.delegate, "usernameField")
        XCTAssertNotNil(sut.passwordField.delegate, "passwordField")
    }

    func test_shouldChangeCharacters_usernameWithSpaces_shouldPreventChange() {
        let allowChange = shouldChangeCharacters(in: sut.usernameField, replacement: "a b")
        XCTAssertEqual(allowChange, false)
    }

    func test_shouldChangeCharacters_usernameWithoutSpaces_shouldAllowChange() {
        let allowChange = shouldChangeCharacters(in: sut.usernameField, replacement: "abc")
        XCTAssertEqual(allowChange, true)
    }

    func test_shouldChangeCharacters_passwordWithSpaces_shouldAllowChange() {
        let allowChange = shouldChangeCharacters(in: sut.passwordField, replacement: "a b")
        XCTAssertEqual(allowChange, true)
    }

    func test_shouldChangeCharacters_passwordWithoutSpaces_shouldAllowChange() {
        let allowChange = shouldChangeCharacters(in: sut.passwordField, replacement: "abc")
        XCTAssertEqual(allowChange, true)
    }
}
