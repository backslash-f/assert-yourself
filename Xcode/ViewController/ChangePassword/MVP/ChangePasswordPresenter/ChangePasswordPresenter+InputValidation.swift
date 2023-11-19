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
            view.showAlert(message: viewModel.enterNewPasswordMessage) { [weak self] in
                self?.view.updateInputFocus(.newPassword)
            }
            return false
        }

        if passwordInputs.isNewPasswordTooShort {
            view.showAlert(message: viewModel.newPasswordTooShortMessage) { [weak self] in
                self?.view.resetNewPasswords()
            }
            return false
        }

        if passwordInputs.isConfirmPasswordMismatched {
            view.showAlert(
                message: viewModel.confirmationPasswordDoesNotMatchMessage
            ) { [weak self] in
                self?.view.resetNewPasswords()
            }
            return false
        }

        return true
    }
}
