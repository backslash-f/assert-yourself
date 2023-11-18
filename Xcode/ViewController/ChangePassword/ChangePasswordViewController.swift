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

    lazy var passwordChanger: PasswordChanging = PasswordChanger()

    var securityToken = ""

    let viewModel: ChangePasswordViewModel!

    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let activityIndicator = UIActivityIndicatorView(style: .large)

    @IBAction func changePassword() {
        if validateInputs() {
            setupWaitingAppearance()
            attemptToChangePassword()
        }
    }

    // MARK: - Lifecycle

    init(viewModel: ChangePasswordViewModel = ChangePasswordViewModel()) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        self.viewModel = ChangePasswordViewModel()
        super.init(coder: coder)
    }

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
        view.endEditing(true)
        dismiss(animated: true)
    }

    func attemptToChangePassword() {
        passwordChanger.change(
            securityToken: securityToken,
            oldPassword: oldPasswordTextField.text ?? "",
            newPassword: newPasswordTextField.text ?? "",

            onSuccess: { [weak self] in
                self?.handleSuccess()
            },

            onFailure: { [weak self] message in
                self?.handleFailure(message: message)
            }
        )
    }

    func setupWaitingAppearance() {
        view.endEditing(true)
        cancelBarButton.isEnabled = false
        view.backgroundColor = .clear
        view.addSubview(blurView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        activityIndicator.startAnimating()
    }

    func validateInputs() -> Bool {
        if oldPasswordTextField.text?.isEmpty ?? true {
            oldPasswordTextField.becomeFirstResponder()
            return false
        }

        if newPasswordTextField.text?.isEmpty ?? true {
            showAlert(message: viewModel.enterNewPasswordMessage) { [weak self] _ in
                self?.newPasswordTextField.becomeFirstResponder()
            }
            return false
        }

        if newPasswordTextField.text?.count ?? 0 < 6 {
            showAlert(message: viewModel.newPasswordTooShortMessage) { [weak self] _ in
                self?.resetNewPasswords()
            }
            return false
        }

        if newPasswordTextField.text != confirmPasswordTextField.text {
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
        newPasswordTextField.becomeFirstResponder()
    }

    func hideSpinner() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }

    func startOver() {
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
        oldPasswordTextField.becomeFirstResponder()
        view.backgroundColor = .white
        blurView.removeFromSuperview()
        cancelBarButton.isEnabled = true
    }

    func handleSuccess() {
        hideSpinner()
        showAlert(message: viewModel.successMessage) { [weak self] _ in
            self?.dismiss(animated: true)
        }
    }

    func handleFailure(message: String) {
        hideSpinner()
        showAlert(message: message) { [weak self] _ in
            self?.startOver()
        }
    }

    func showAlert(message: String, okAction: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert)

        let okButton = UIAlertAction(
            title: viewModel.okButtonLabel,
            style: .default,
            handler: okAction
        )

        alertController.addAction(okButton)
        alertController.preferredAction = okButton
        self.present(alertController, animated: true)
    }
}
