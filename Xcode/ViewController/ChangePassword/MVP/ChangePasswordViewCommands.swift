//
//  ChangePasswordViewCommands.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 19.11.23.
//

import Foundation

protocol ChangePasswordViewCommands: AnyObject {
    func attemptToChangePassword()
    func dismissModal()
    func hideActivityIndicator()
    func hideBlurView()
    func resetNewPasswords()
    func setCancelButtonEnabled(_ enabled: Bool)
    func setupWaitingAppearance()
    func showActivityIndicator()
    func showBlurView()
    func showAlert(message: String, action: @escaping () -> Void)
    func updateInputFocus(_ inputFocus: InputFocus)
}

enum InputFocus {
    case noKeyboard
    case oldPassword
    case newPassword
    case confirmPassword
}
