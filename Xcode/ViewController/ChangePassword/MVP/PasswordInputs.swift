//
//  PasswordInputs.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 19.11.23.
//

import Foundation

struct PasswordInputs {
    let oldPassword: String
    let newPassword: String
    let confirmPassword: String

    var isOldPasswordEmpty: Bool {
        oldPassword.isEmpty
    }

    var isNewPasswordEmpty: Bool {
        newPassword.isEmpty
    }

    var isNewPasswordTooShort: Bool {
        newPassword.count < 6
    }

    var isConfirmPasswordMismatched: Bool {
        newPassword != confirmPassword
    }
}
