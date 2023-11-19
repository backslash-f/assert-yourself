//
//  ChangePasswordPresenter+InputValidation.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 19.11.23.
//

import Foundation

extension ChangePasswordPresenter {
    func validateInputs(passwordInputs: PasswordInputs) -> Bool {
        if passwordInputs.isOldPasswordEmpty {
            view.updateInputFocus(.oldPassword)
            return false
        }

        if passwordInputs.isNewPasswordEmpty {
            view.showAlert(message: labels.enterNewPasswordMessage) { [weak self] in
                self?.view.updateInputFocus(.newPassword)
            }
            return false
        }

        if passwordInputs.isNewPasswordTooShort {
            view.showAlert(message: labels.newPasswordTooShortMessage) { [weak self] in
                self?.resetNewPasswords()
            }
            return false
        }

        if passwordInputs.isConfirmPasswordMismatched {
            view.showAlert(
                message: labels.confirmationPasswordDoesNotMatchMessage
            ) { [weak self] in
                self?.resetNewPasswords()
            }
            return false
        }

        return true
    }
}

// MARK: - Private

private extension ChangePasswordPresenter {
    func resetNewPasswords() {
        view.clearNewPasswordFields()
        view.updateInputFocus(.newPassword)
    }
}
