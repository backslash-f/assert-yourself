//
//  PasswordInputs.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 19.11.23.
//

import Foundation

struct PasswordInputs {
    var oldPassword = ""
    var isOldPasswordEmpty: Bool {
        oldPassword.isEmpty
    }

    var newPassword = ""
    var isNewPasswordEmpty: Bool {
        newPassword.isEmpty
    }
    var isNewPasswordTooShort: Bool {
        newPassword.count < 6
    }

    var confirmPassword = ""
    var isConfirmPasswordMismatched: Bool {
        newPassword != confirmPassword
    }
}
