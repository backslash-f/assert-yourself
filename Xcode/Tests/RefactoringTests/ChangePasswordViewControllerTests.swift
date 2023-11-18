//
//  RefactoringTests.swift
//  RefactoringTests
//
//  Created by Fernando Fernandes on 14.11.23.
//

import ViewControllerPresentationSpy
import XCTest

@testable import AssertYourself

// swiftlint:disable:next type_body_length
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
        putFocusOn(.oldPassword)
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder, "precondition")
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.oldPasswordTextField.isFirstResponder)
    }

    func test_tappingCancel_withFocusOnNewPassword_shouldResignThatFocus() {
        putFocusOn(.newPassword)
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder, "precondition")
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.newPasswordTextField.isFirstResponder)
    }

    func test_tappingCancel_withFocusConfirmPassword_shouldResignThatFocus() {
        putFocusOn(.confirmPassword)
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
            message: "The new password and the confirmation password don’t match. Please try again."
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
        putFocusOn(.oldPassword)
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder, "precondition")
        tap(sut.submitButton)
        XCTAssertFalse(sut.oldPasswordTextField.isFirstResponder)
    }

    func test_tappingSubmit_withValidFieldsFocusedOnNewPassword_resignsFocus() {
        setUpPasswordEntries()
        putFocusOn(.newPassword)
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder, "precondition")
        tap(sut.submitButton)
        XCTAssertFalse(sut.newPasswordTextField.isFirstResponder)
    }

    func test_tappingSubmit_withValidFieldsFocusedOnConfirmPassword_resignsFocus() {
        setUpPasswordEntries()
        putFocusOn(.confirmPassword)
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

    // MARK: - Waiting State

    func test_tappingSubmit_withValidFields_shouldShowBlurView() {
        setUpPasswordEntries()
        XCTAssertNil(sut.blurView.superview, "precondition")
        tap(sut.submitButton)
        XCTAssertNotNil(sut.blurView.superview)
    }

    func test_tappingSubmit_withValidFields_shouldShowActivityIndicator() {
        setUpPasswordEntries()
        XCTAssertNil(sut.activityIndicator.superview, "precondition")
        tap(sut.submitButton)
        XCTAssertNotNil(sut.activityIndicator.superview)
    }

    func test_tappingSubmit_withValidFields_shouldStartActivityAnimation() {
        setUpPasswordEntries()
        XCTAssertFalse(sut.activityIndicator.isAnimating, "precondition")
        tap(sut.submitButton)
        XCTAssertTrue(sut.activityIndicator.isAnimating)
    }

    func test_tappingSubmit_withValidFields_shouldClearBackgroundColorForBlur() {
        setUpPasswordEntries()
        XCTAssertNotEqual(sut.view.backgroundColor, .clear, "precondition")
        tap(sut.submitButton)
        XCTAssertEqual(sut.view.backgroundColor, .clear)
    }

    // MARK: - Password Changer

    func test_tappingSubmit_withValidFields_shouldRequestChangePassword() {
        sut.securityToken = "TOKEN"
        sut.oldPasswordTextField.text = "OLD456"
        sut.newPasswordTextField.text = "NEW456"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
        tap(sut.submitButton)
        passwordChanger.verifyChange(
            securityToken: "TOKEN",
            oldPassword: "OLD456",
            newPassword: "NEW456"
        )
    }

    func test_changePasswordSuccess_shouldStopActivityIndicatorAnimation() {
        setUpPasswordEntries()
        tap(sut.submitButton)
        XCTAssertTrue(sut.activityIndicator.isAnimating, "precondition")
        passwordChanger.changeCallSuccess()
        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }

    func test_changePasswordSuccess_shouldHideActivityIndicator() {
        setUpPasswordEntries()
        tap(sut.submitButton)
        XCTAssertNotNil(sut.activityIndicator.superview, "precondition")
        passwordChanger.changeCallSuccess()
        XCTAssertNil(sut.activityIndicator.superview)
    }

    func test_changePasswordFailure_shouldStopActivityIndicatorAnimation() {
        setUpPasswordEntries()
        tap(sut.submitButton)
        XCTAssertTrue(sut.activityIndicator.isAnimating, "precondition")
        passwordChanger.changeCallFailure(message: "DUMMY")
        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }

    func test_changePasswordFailure_shouldHideActivityIndicator() {
        setUpPasswordEntries()
        tap(sut.submitButton)
        XCTAssertNotNil(sut.activityIndicator.superview, "precondition")
        passwordChanger.changeCallFailure(message: "DUMMY")
        XCTAssertNil(sut.activityIndicator.superview)
    }

    @MainActor
    func test_changePasswordSuccess_shouldShowSuccessAlert() {
        setUpPasswordEntries()
        tap(sut.submitButton)
        passwordChanger.changeCallSuccess()
        verifyAlertPresented(message: "Your password has been successfully changed.")
    }

    @MainActor
    func test_tappingOKInSuccessAlert_shouldDismissModal() throws {
        setUpPasswordEntries()
        tap(sut.submitButton)
        passwordChanger.changeCallSuccess()
        let dismissalVerifier = DismissalVerifier()
        try alertVerifier.executeAction(forButton: "OK")
        dismissalVerifier.verify(animated: true, dismissedViewController: sut)
    }

    @MainActor
    func test_changePasswordFailure_shouldShowFailureAlertWithGivenMessage() {
        setUpPasswordEntries()
        tap(sut.submitButton)
        passwordChanger.changeCallFailure(message: "MESSAGE")
        verifyAlertPresented(message: "MESSAGE")
    }

    @MainActor
    func test_tappingOKInFailureAlert_shouldClearAllFieldsToStartOver() throws {
        showPasswordChangeFailureAlert()
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(sut.oldPasswordTextField.text?.isEmpty, true, "old")
        XCTAssertEqual(sut.newPasswordTextField.text?.isEmpty, true, "new")
        XCTAssertEqual(sut.confirmPasswordTextField.text?.isEmpty, true, "confirmation")
    }

    @MainActor
    func test_tappingOKInFailureAlert_shouldPutFocusOnOldPassword() throws {
        showPasswordChangeFailureAlert()
        putInViewHierarchy(sut)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder)
    }

    @MainActor
    func test_tappingOKInFailureAlert_shouldSetBackgroundBackToWhite() throws {
        showPasswordChangeFailureAlert()
        XCTAssertNotEqual(sut.view.backgroundColor, .white, "precondition")
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(sut.view.backgroundColor, .white)
    }

    @MainActor
    func test_tappingOKInFailureAlert_shouldHideBlur() throws {
        showPasswordChangeFailureAlert()
        XCTAssertNotNil(sut.blurView.superview, "precondition")
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertNil(sut.blurView.superview)
    }

    @MainActor
    func test_tappingOKInFailureAlert_shouldEnableCancelBarButton() throws {
        showPasswordChangeFailureAlert()
        XCTAssertFalse(sut.cancelBarButton.isEnabled, "precondition")
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertTrue(sut.cancelBarButton.isEnabled)
    }

    @MainActor
    func test_tappingOKInFailureAlert_shouldNotDismissModal() throws {
        showPasswordChangeFailureAlert()
        let dismissalVerifier = DismissalVerifier()
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(dismissalVerifier.dismissedCount, 0)
    }

    // MARK: - Text Field

    func test_textFieldDelegates_shouldBeConnected() {
        XCTAssertNotNil(sut.oldPasswordTextField.delegate, "oldPasswordTextField")
        XCTAssertNotNil(sut.newPasswordTextField.delegate, "updatedPasswordTextField")
        XCTAssertNotNil(sut.confirmPasswordTextField.delegate, "confirmPasswordTextField")
    }

    func test_hittingReturnFromOldPassword_shouldPutFocusOnNewPassword() {
        putInViewHierarchy(sut)
        shouldReturn(in: sut.oldPasswordTextField)
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder)
    }

    func test_hittingReturnFromNewPassword_shouldPutFocusOnConfirmPassword() {
        putInViewHierarchy(sut)
        shouldReturn(in: sut.newPasswordTextField)
        XCTAssertTrue(sut.confirmPasswordTextField.isFirstResponder)
    }

    func test_hittingReturnFromConfirmPassword_shouldRequestPasswordChange() {
        sut.securityToken = "TOKEN"
        sut.oldPasswordTextField.text = "OLD456"
        sut.newPasswordTextField.text = "NEW456"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
        shouldReturn(in: sut.confirmPasswordTextField)
        passwordChanger.verifyChange(
            securityToken: "TOKEN",
            oldPassword: "OLD456",
            newPassword: "NEW456"
        )
    }

    func test_hittingReturnFromOldPassword_shouldNotRequestPasswordChange() {
        setUpPasswordEntries()
        shouldReturn(in: sut.oldPasswordTextField)
        passwordChanger.verifyChangeNeverCalled()
    }

    func test_hittingReturnFromNewPassword_shouldNotRequestPasswordChange() {
        setUpPasswordEntries()
        shouldReturn(in: sut.newPasswordTextField)
        passwordChanger.verifyChangeNeverCalled()
    }
}

private extension ChangePasswordViewControllerTests {
    func putFocusOn(_ inputFocus: ChangePasswordViewModel.InputFocus) {
        putInViewHierarchy(sut)
        sut.viewModel.inputFocus = inputFocus
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

        // swiftlint:disable file_length

        XCTAssertEqual(
            alertVerifier.preferredAction?.title, "OK",
            "preferred action",
            file: file,
            line: line
        )
    }

    func showPasswordChangeFailureAlert() {
        setUpPasswordEntries()
        tap(sut.submitButton)
        passwordChanger.changeCallFailure(message: "DUMMY")
    }
}
