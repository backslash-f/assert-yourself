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

    private lazy var presenter = ChangePasswordPresenter(
        view: self,
        viewModel: viewModel,
        securityToken: securityToken,
        passwordChanger: passwordChanger
    )

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let activityIndicator = UIActivityIndicatorView(style: .large)

    @IBAction func changePassword() {
        updateViewModelToTextFields()
        if validateInputs(passwordInputs: viewModel.passwordInputs) {
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

    func updateViewModelToTextFields() {
        viewModel.passwordInputs.oldPassword = oldPasswordTextField.text ?? ""
        viewModel.passwordInputs.newPassword = newPasswordTextField.text ?? ""
        viewModel.passwordInputs.confirmPassword = confirmPasswordTextField.text ?? ""
    }
}
