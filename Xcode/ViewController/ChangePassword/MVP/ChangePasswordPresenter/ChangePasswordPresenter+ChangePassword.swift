//
//  ChangePasswordPresenter+PasswordChange.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 19.11.23.
//

import Foundation

extension ChangePasswordPresenter {
    func changePassword(passwordInputs: PasswordInputs) {
        if validateInputs(passwordInputs: passwordInputs) {
            setupWaitingAppearance()
            attemptToChangePassword(passwordInputs: passwordInputs)
        }
    }

    func attemptToChangePassword(passwordInputs: PasswordInputs) {
        passwordChanger.change(
            securityToken: securityToken,
            oldPassword: passwordInputs.oldPassword,
            newPassword: passwordInputs.newPassword,

            onSuccess: { [weak self] in
                self?.handleSuccess()
            },

            onFailure: { [weak self] message in
                self?.handleFailure(message: message)
            }
        )
    }

    func cancel() {
        view.updateInputFocus(.noKeyboard)
        view.dismissModal()
    }
}

// MARK: - Private

private extension ChangePasswordPresenter {
    func handleFailure(message: String) {
        view.hideActivityIndicator()
        view.showAlert(message: message) { [weak self] in
            self?.startOver()
        }
    }

    func handleSuccess() {
        view.hideActivityIndicator()
        view.showAlert(message: labels.successMessage) { [weak self] in
            self?.view.dismissModal()
        }
    }

    func startOver() {
        view.clearAllPasswordFields()
        view.updateInputFocus(.oldPassword)
        view.setCancelButtonEnabled(true)
        view.hideBlurView()
    }
}
