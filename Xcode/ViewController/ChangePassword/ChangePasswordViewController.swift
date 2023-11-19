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

    lazy var viewModel = ChangePasswordViewModel() {
        didSet {
            guard isViewLoaded else { return }

            if oldValue.isCancelButtonEnabled != viewModel.isCancelButtonEnabled {
                cancelBarButton.isEnabled = viewModel.isCancelButtonEnabled
            }

            if oldValue.inputFocus != viewModel.inputFocus {
                updateInputFocus()
            }

            if oldValue.isBlurViewShowing != viewModel.isBlurViewShowing {
                updateBlurView()
            }
        }
    }

    private lazy var presenter = ChangePasswordPresenter(view: self)

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
        viewModel.inputFocus = .noKeyboard
        dismiss(animated: true)
    }

    func attemptToChangePassword() {
        passwordChanger.change(
            securityToken: securityToken,
            oldPassword: viewModel.oldPassword,
            newPassword: viewModel.newPassword,

            onSuccess: { [weak self] in
                self?.handleSuccess()
            },

            onFailure: { [weak self] message in
                self?.handleFailure(message: message)
            }
        )
    }

    func setupWaitingAppearance() {
        viewModel.isBlurViewShowing = true
        viewModel.inputFocus = .noKeyboard
        viewModel.isCancelButtonEnabled = false
        showActivityIndicator()
    }

    func validateInputs() -> Bool {
        if viewModel.isOldPasswordEmpty {
            viewModel.inputFocus = .oldPassword
            return false
        }

        if viewModel.isNewPasswordEmpty {
            showAlert(message: viewModel.enterNewPasswordMessage) { [weak self] _ in
                self?.viewModel.inputFocus = .newPassword
            }
            return false
        }

        if viewModel.isNewPasswordTooShort {
            showAlert(message: viewModel.newPasswordTooShortMessage) { [weak self] _ in
                self?.resetNewPasswords()
            }
            return false
        }

        if viewModel.isConfirmPasswordMismatched {
            showAlert(
                message: viewModel.confirmationPasswordDoesNotMatchMessage
            ) { [weak self] _ in
                self?.resetNewPasswords()
            }
            return false
        }

        return true
    }

    func resetNewPasswords() {
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
        viewModel.inputFocus = .newPassword
    }

    func startOver() {
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
        viewModel.inputFocus = .oldPassword
        viewModel.isCancelButtonEnabled = true
        viewModel.isBlurViewShowing = false
    }

    func handleSuccess() {
        hideActivityIndicator()
        showAlert(message: viewModel.successMessage) { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }

    func handleFailure(message: String) {
        hideActivityIndicator()
        showAlert(message: message) { [weak self] _ in
            self?.startOver()
        }
    }

    func updateInputFocus() {
        switch viewModel.inputFocus {
        case .noKeyboard:
            view.endEditing(true)
        case .oldPassword:
            oldPasswordTextField.becomeFirstResponder()
        case .newPassword:
            newPasswordTextField.becomeFirstResponder()
        case .confirmPassword:
            confirmPasswordTextField.becomeFirstResponder()
        }
    }

    func updateBlurView() {
        if viewModel.isBlurViewShowing {
            view.backgroundColor = .clear
            view.addSubview(blurView)
            NSLayoutConstraint.activate([
                blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
                blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        } else {
            view.backgroundColor = .white
            blurView.removeFromSuperview()
        }
    }

    func updateViewModelToTextFields() {
        viewModel.oldPassword = oldPasswordTextField.text ?? ""
        viewModel.newPassword = newPasswordTextField.text ?? ""
        viewModel.confirmPassword = confirmPasswordTextField.text ?? ""
    }
}
