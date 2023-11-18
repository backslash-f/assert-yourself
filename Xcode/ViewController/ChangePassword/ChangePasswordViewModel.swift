//
//  ChangePasswordViewModel.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 18.11.23.
//

import Foundation

struct ChangePasswordViewModel {
    let okButtonLabel: String
    let enterNewPasswordMessage: String
    let newPasswordTooShortMessage: String
    let confirmationPasswordDoesNotMatchMessage: String
    let successMessage: String

    init(okButtonLabel: String = "OK",
         enterNewPasswordMessage: String = "Please enter a new password.",
         newPasswordTooShortMessage: String = "The new password should have at least 6 characters.",
         confirmationPasswordDoesNotMatchMessage: String = """
        The new password and the confirmation password don’t match. Please try again.
        """,
         successMessage: String = "Your password has been successfully changed.") {
        self.okButtonLabel = okButtonLabel
        self.enterNewPasswordMessage = enterNewPasswordMessage
        self.newPasswordTooShortMessage = newPasswordTooShortMessage
        self.confirmationPasswordDoesNotMatchMessage = confirmationPasswordDoesNotMatchMessage
        self.successMessage = successMessage
    }
}
