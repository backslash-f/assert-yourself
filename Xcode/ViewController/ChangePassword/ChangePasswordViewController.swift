//
//  ChangePasswordViewController.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 14.11.23.
//

import Foundation
import UIKit

class ChangePasswordViewController: UIViewController {
    @IBOutlet private(set) var navigationBar: UINavigationBar!
    @IBOutlet private(set) var cancelBarButton: UIBarButtonItem!
    @IBOutlet private(set) var oldPasswordTextField: UITextField!
    @IBOutlet private(set) var newPasswordTextField: UITextField!
    @IBOutlet private(set) var confirmPasswordTextField: UITextField!
    @IBOutlet private(set) var submitButton: UIButton!

    var securityToken = ""

    lazy var passwordChanger: PasswordChanging = PasswordChanger()

    lazy var viewModel = ChangePasswordViewModel()

    private lazy var presenter = ChangePasswordPresenter(view: self,
                                                         viewModel: viewModel)

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let activityIndicator = UIActivityIndicatorView(style: .large)

    @IBAction func changePassword() {
        updateViewModelToTextFields()
        if validateInputs() {
            setupWaitingAppearance()
            attemptToChangePassword()
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupSubmitButton()
        setupBlurView()
        setupActivityIndicator()
    }
}

private extension ChangePasswordViewController {
    @IBAction private func cancel() {
        updateInputFocus(.noKeyboard)
        dismissModal()
    }

    func attemptToChangePassword() {
        passwordChanger.change(
            securityToken: securityToken,
            oldPassword: viewModel.oldPassword,
            newPassword: viewModel.newPassword,

            onSuccess: { [weak self] in
                self?.presenter.handleSuccess()
            },

            onFailure: { [weak self] message in
                self?.handleFailure(message: message)
            }
        )
    }

    func setupWaitingAppearance() {
        showBlurView()
        updateInputFocus(.noKeyboard)
        setCancelButtonEnabled(false)
        showActivityIndicator()
    }

    func validateInputs() -> Bool {
        if viewModel.isOldPasswordEmpty {
            updateInputFocus(.oldPassword)
            return false
        }

        if viewModel.isNewPasswordEmpty {
            showAlert(message: viewModel.enterNewPasswordMessage) { [weak self] in
                self?.updateInputFocus(.newPassword)
            }
            return false
        }

        if viewModel.isNewPasswordTooShort {
            showAlert(message: viewModel.newPasswordTooShortMessage) { [weak self] in
                self?.resetNewPasswords()
            }
            return false
        }

        if viewModel.isConfirmPasswordMismatched {
            showAlert(
                message: viewModel.confirmationPasswordDoesNotMatchMessage
            ) { [weak self] in
                self?.resetNewPasswords()
            }
            return false
        }

        return true
    }

    func resetNewPasswords() {
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
        updateInputFocus(.newPassword)
    }

    func startOver() {
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
        updateInputFocus(.oldPassword)
        setCancelButtonEnabled(true)
        hideBlurView()
    }

    func handleFailure(message: String) {
        hideActivityIndicator()
        showAlert(message: message) { [weak self] in
            self?.startOver()
        }
    }

    func updateViewModelToTextFields() {
        viewModel.oldPassword = oldPasswordTextField.text ?? ""
        viewModel.newPassword = newPasswordTextField.text ?? ""
        viewModel.confirmPassword = confirmPasswordTextField.text ?? ""
    }
}
