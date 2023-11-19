//
//  ChangePasswordViewController+Commands.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 19.11.23.
//

import Foundation
import UIKit

extension ChangePasswordViewController: ChangePasswordViewCommands {
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

    func dismissModal() {
        dismiss(animated: true)
    }

    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }

    func hideBlurView() {
        view.backgroundColor = .white
        blurView.removeFromSuperview()
    }

    func setCancelButtonEnabled(_ enabled: Bool) {
        cancelBarButton.isEnabled = enabled
    }

    func showActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }

    func showAlert(message: String, action: @escaping () -> Void) {
        let wrappedAction: (UIAlertAction) -> Void = { _ in action() }
        showAlert(message: message) {
            wrappedAction($0)
        }
    }

    func showBlurView() {
        view.backgroundColor = .clear
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }

    func updateInputFocus(_ inputFocus: InputFocus) {
        switch inputFocus {
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
}

// MARK: - Private

private extension ChangePasswordViewController {
    func clearAllPasswordFields() {
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
    }

    func handleFailure(message: String) {
        hideActivityIndicator()
        showAlert(message: message) { [weak self] in
            self?.startOver()
        }
    }

    func handleSuccess() {
        hideActivityIndicator()
        showAlert(message: viewModel.successMessage) { [weak self] in
            self?.dismissModal()
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
        present(alertController, animated: true)
    }

    func startOver() {
        clearAllPasswordFields()
        updateInputFocus(.oldPassword)
        setCancelButtonEnabled(true)
        hideBlurView()
    }
}
