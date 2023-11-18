//
//  ChangePasswordViewModel.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 18.11.23.
//

import Foundation

struct ChangePasswordViewModel {
    let title: String
    let okButtonLabel: String
    let submitButtonLabel: String
    let successMessage: String

    let oldPasswordPlaceholder: String

    let enterNewPasswordMessage: String
    let newPasswordPlaceholder: String
    let newPasswordTooShortMessage: String

    let confirmPasswordPlaceholder: String
    let confirmationPasswordDoesNotMatchMessage: String

    var isCancelButtonEnabled = true

    var inputFocus: InputFocus = .noKeyboard

    init(title: String = "Change Password",
         okButtonLabel: String = "OK",
         submitButtonLabel: String = "Submit",
         successMessage: String = "Your password has been successfully changed.",
         oldPasswordPlaceholder: String = "Current Password",
         enterNewPasswordMessage: String = "Please enter a new password.",
         newPasswordPlaceholder: String = "New Password",
         newPasswordTooShortMessage: String = "The new password should have at least 6 characters.",
         confirmPasswordPlaceholder: String = "Confirm New Password",
         confirmationPasswordDoesNotMatchMessage: String = """
        The new password and the confirmation password don’t match. Please try again.
        """
    ) {
        self.title = title
        self.okButtonLabel = okButtonLabel
        self.submitButtonLabel = submitButtonLabel
        self.successMessage = successMessage
        self.oldPasswordPlaceholder = oldPasswordPlaceholder
        self.enterNewPasswordMessage = enterNewPasswordMessage
        self.newPasswordPlaceholder = newPasswordPlaceholder
        self.newPasswordTooShortMessage = newPasswordTooShortMessage
        self.confirmPasswordPlaceholder = confirmPasswordPlaceholder
        self.confirmationPasswordDoesNotMatchMessage = confirmationPasswordDoesNotMatchMessage
    }
}
