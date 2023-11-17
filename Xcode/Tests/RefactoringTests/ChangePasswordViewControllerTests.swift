//
//  RefactoringTests.swift
//  RefactoringTests
//
//  Created by Fernando Fernandes on 14.11.23.
//

import ViewControllerPresentationSpy
import XCTest

@testable import AssertYourself

final class ChangePasswordViewControllerTests: XCTestCase {

    private var alertVerifier: AlertVerifier!
    private var passwordChanger: MockPasswordChanger!
    private var sut: ChangePasswordViewController!

    @MainActor
    override func setUp() {
        super.setUp()
        alertVerifier = AlertVerifier()
        passwordChanger = MockPasswordChanger()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: ChangePasswordViewController.self)
        sut = sb.instantiateViewController(identifier: identifier)
        sut.passwordChanger = passwordChanger
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        executeRunLoop() // Clean out UIWindow
        sut = nil
        passwordChanger = nil
        alertVerifier = nil
        super.tearDown()
    }

    // MARK: - UI Elements

    func test_outlets_shouldBeConnected() {
        XCTAssertNotNil(sut.navigationBar, "navigationBar")
        XCTAssertNotNil(sut.cancelBarButton, "cancelButton")
        XCTAssertNotNil(sut.oldPasswordTextField, "oldPasswordTextField")
        XCTAssertNotNil(sut.newPasswordTextField, "newPasswordTextField")
        XCTAssertNotNil(sut.confirmPasswordTextField, "confirmPasswordTextField")
        XCTAssertNotNil(sut.submitButton, "submitButton")
    }

    func test_navigationBar_shouldHaveTitle() {
        XCTAssertEqual(sut.navigationBar.topItem?.title, "Change Password")
    }

    func test_cancelBarButton_shouldBeSystemItemCancel() {
        XCTAssertEqual(systemItem(for: sut.cancelBarButton), .cancel)
    }

    func test_oldPasswordTextField_shouldHavePlaceholder() {
        XCTAssertEqual(sut.oldPasswordTextField.placeholder, "Current Password")
    }

    func test_newPasswordTextField_shouldHavePlaceholder() {
        XCTAssertEqual(sut.newPasswordTextField.placeholder, "New Password")
    }

    func test_confirmPasswordTextField_shouldHavePlaceholder() {
        XCTAssertEqual(sut.confirmPasswordTextField.placeholder, "Confirm New Password")
    }

    func test_submitButton_shouldHaveTitle() {
        XCTAssertEqual(sut.submitButton.titleLabel?.text, "Submit")
    }

    func test_oldPasswordTextField_shouldHavePasswordAttributes() {
        let textField = sut.oldPasswordTextField!
        XCTAssertEqual(textField.textContentType, .password, "textContentType")
        XCTAssertTrue(textField.isSecureTextEntry, "isSecureTextEntry")
        XCTAssertTrue(textField.enablesReturnKeyAutomatically, "enablesReturnKeyAutomatically")
    }

    func test_newPasswordTextField_shouldHavePasswordAttributes() {
        let textField = sut.newPasswordTextField!
        XCTAssertEqual(textField.textContentType, .newPassword, "textContentType")
        XCTAssertTrue(textField.isSecureTextEntry, "isSecureTextEntry")
        XCTAssertTrue(textField.enablesReturnKeyAutomatically, "enablesReturnKeyAutomatically")
    }

    func test_confirmPasswordTextField_shouldHavePasswordAttributes() {
        let textField = sut.confirmPasswordTextField!
        XCTAssertEqual(textField.textContentType, .newPassword, "textContentType")
        XCTAssertTrue(textField.isSecureTextEntry, "isSecureTextEntry")
        XCTAssertTrue(textField.enablesReturnKeyAutomatically, "enablesReturnKeyAutomatically")
    }

    // MARK: - Behavior

    func test_tappingCancel_withFocusOnOldPassword_shouldResignThatFocus() {
        putFocusOn(textField: sut.oldPasswordTextField)
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder, "precondition")
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.oldPasswordTextField.isFirstResponder)
    }

    func test_tappingCancel_withFocusOnNewPassword_shouldResignThatFocus() {
        putFocusOn(textField: sut.newPasswordTextField)
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder, "precondition")
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.newPasswordTextField.isFirstResponder)
    }

    func test_tappingCancel_withFocusConfirmPassword_shouldResignThatFocus() {
        putFocusOn(textField: sut.confirmPasswordTextField)
        XCTAssertTrue(sut.confirmPasswordTextField.isFirstResponder, "precondition")
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.confirmPasswordTextField.isFirstResponder)
    }

    @MainActor
    func test_tappingCancel_shouldDismissModal() {
        let dismissalVerifier = DismissalVerifier()
        tap(sut.cancelBarButton)
        dismissalVerifier.verify(animated: true, dismissedViewController: sut)
    }

    func test_tappingSubmit_withOldPasswordEmpty_shouldNotChangePassword() {
        setUpPasswordEntries()
        sut.oldPasswordTextField.text = ""
        tap(sut.submitButton)
        passwordChanger.verifyChangeNeverCalled()
    }

    func test_tappingSubmit_withOldPasswordEmpty_shouldPutFocusOnOldPassword() {
        setUpPasswordEntries()
        sut.oldPasswordTextField.text = ""
        putInViewHierarchy(sut)
        tap(sut.submitButton)
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder)
    }

    func test_tappingSubmit_withNewPasswordEmpty_shouldNotChangePassword() {
        setUpPasswordEntries()
        sut.newPasswordTextField.text = ""
        tap(sut.submitButton)
        passwordChanger.verifyChangeNeverCalled()
    }

    @MainActor
    func test_tappingSubmit_withNewPasswordEmpty_shouldShowPasswordBlankAlert() {
        setUpPasswordEntries()
        sut.newPasswordTextField.text = ""
        tap(sut.submitButton)
        verifyAlertPresented(message: "Please enter a new password.")
    }

    @MainActor
    func test_tappingOKPasswordBlankAlert_shouldPutFocusOnNewPassword() throws { setUpPasswordEntries()
        sut.newPasswordTextField.text = ""
        tap(sut.submitButton)
        putInViewHierarchy(sut)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder)
    }

    @MainActor
    func test_tappingSubmit_withNewPasswordTooShort_shouldNotChangePassword() {
        setUpPasswordEntries(isNewPasswordShort: true)
        tap(sut.submitButton)
        passwordChanger.verifyChangeNeverCalled()
    }

    @MainActor
    func test_tappingSubmit_withNewPasswordTooShort_shouldShowTooShortAlert() {
        setUpPasswordEntries(isNewPasswordShort: true)
        tap(sut.submitButton)
        verifyAlertPresented(message: "The new password should have at least 6 characters.")
    }

    @MainActor
    func test_tappingOKInTooShortAlert_shouldClearNewAndConfirmation() throws {
        setUpPasswordEntries(isNewPasswordShort: true)
        tap(sut.submitButton)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(sut.newPasswordTextField.text?.isEmpty, true, "new")
        XCTAssertEqual(sut.confirmPasswordTextField.text?.isEmpty, true, "confirmation")
    }

    @MainActor
    func test_tappingOKInTooShortAlert_shouldNotClearOldPasswordField() throws {
        setUpPasswordEntries(isNewPasswordShort: true)
        tap(sut.submitButton)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(sut.oldPasswordTextField.text?.isEmpty, false)
    }

    @MainActor
    // swiftlint:disable:next line_length
    func test_tappingOKInTooShortAlert_shouldPutFocusOnNewPassword() throws { setUpPasswordEntries(isNewPasswordShort: true)
        tap(sut.submitButton)
        putInViewHierarchy(sut)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder)
    }

    @MainActor
    func test_tappingSubmit_withConfirmationMismatch_shouldNotChangePassword() {
        setUpPasswordEntries(isMismatch: true)
        tap(sut.submitButton)
        passwordChanger.verifyChangeNeverCalled()
    }

    @MainActor
    func test_tappingSubmit_withConfirmationMismatch_shouldShowMismatchAlert() {
        setUpPasswordEntries(isMismatch: true)
        tap(sut.submitButton)
        verifyAlertPresented(
            message: "The new password and the confirmation password " + "don’t match. Please try again."
        )
    }

    @MainActor
    func test_tappingOKInMismatchAlert_shouldClearNewAndConfirmation() throws {
        setUpPasswordEntries(isMismatch: true)
        tap(sut.submitButton)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(sut.newPasswordTextField.text?.isEmpty, true, "new")
        XCTAssertEqual(sut.confirmPasswordTextField.text?.isEmpty, true, "confirmation")
    }

    @MainActor
    func test_tappingOKInMismatchAlert_shouldNotClearOldPasswordField() throws {
        setUpPasswordEntries(isMismatch: true)
        tap(sut.submitButton)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(sut.oldPasswordTextField.text?.isEmpty, false)
    }

    @MainActor
    func test_tappingOKInMismatchAlert_shouldPutFocusOnNewPassword() throws { setUpPasswordEntries(isMismatch: true)
        tap(sut.submitButton)
        putInViewHierarchy(sut)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder)
    }

    func test_tappingSubmit_withValidFieldsFocusedOnOldPassword_resignsFocus() {
        setUpPasswordEntries()
        putFocusOn(textField: sut.oldPasswordTextField)
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder, "precondition")
        tap(sut.submitButton)
        XCTAssertFalse(sut.oldPasswordTextField.isFirstResponder)
    }

    func test_tappingSubmit_withValidFieldsFocusedOnNewPassword_resignsFocus() {
        setUpPasswordEntries()
        putFocusOn(textField: sut.newPasswordTextField)
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder, "precondition")
        tap(sut.submitButton)
        XCTAssertFalse(sut.newPasswordTextField.isFirstResponder)
    }

    func test_tappingSubmit_withValidFieldsFocusedOnConfirmPassword_resignsFocus() {
        setUpPasswordEntries()
        putFocusOn(textField: sut.confirmPasswordTextField)
        XCTAssertTrue(sut.confirmPasswordTextField.isFirstResponder, "precondition")
        tap(sut.submitButton)
        XCTAssertFalse(sut.confirmPasswordTextField.isFirstResponder)
    }

    func test_tappingSubmit_withValidFields_shouldDisableCancelBarButton() {
        setUpPasswordEntries()
        XCTAssertTrue(sut.cancelBarButton.isEnabled, "precondition")
        tap(sut.submitButton)
        XCTAssertFalse(sut.cancelBarButton.isEnabled)
    }
}

private extension ChangePasswordViewControllerTests {
    func putFocusOn(textField: UITextField) {
        putInViewHierarchy(sut)
        textField.becomeFirstResponder()
    }

    func setUpPasswordEntries(isNewPasswordShort: Bool = false,
                              isMismatch: Bool = false) {
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = isNewPasswordShort ? "12345" : "123456"
        sut.confirmPasswordTextField.text = isMismatch ? "abcdef" : sut.newPasswordTextField.text
    }

    @MainActor
    func verifyAlertPresented(title: String? = "",
                              message: String,
                              file: StaticString = #file,
                              line: UInt = #line) {
        alertVerifier.verify(
            title: title,
            message: message,
            animated: true, actions: [
                .default("OK")
            ],
            presentingViewController: sut,
            file: file,
            line: line
        )

        XCTAssertEqual(
            alertVerifier.preferredAction?.title, "OK",
            "preferred action",
            file: file,
            line: line
        )
    }
}
