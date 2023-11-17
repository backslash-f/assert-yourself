//
//  ChangePasswordViewControllerSnapshotTests.swift
//  RefactoringTests
//
//  Created by Fernando Fernandes on 17.11.23.
//

import iOSSnapshotTestCase
import XCTest

@testable import AssertYourself

// swiftlint:disable:next type_name
final class ChangePasswordViewControllerSnapshotTests: FBSnapshotTestCase {
    private var sut: ChangePasswordViewController!

    @MainActor
    override func setUp() {
        super.setUp()

        recordMode = false

        let sb = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: ChangePasswordViewController.self)
        sut = sb.instantiateViewController(identifier: identifier)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_blur() {
        setUpPasswordEntries()
        tap(sut.submitButton)
        verifySnapshot()
    }
}

private extension ChangePasswordViewControllerSnapshotTests {
    func setUpPasswordEntries(isNewPasswordShort: Bool = false,
                              isMismatch: Bool = false) {
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = isNewPasswordShort ? "12345" : "123456"
        sut.confirmPasswordTextField.text = isMismatch ? "abcdef" : sut.newPasswordTextField.text
    }

    func verifySnapshot(file: StaticString = #file,
                        line: UInt = #line) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.addSubview(sut.view)
        FBSnapshotVerifyViewController(sut, file: file, line: line)
    }
}
