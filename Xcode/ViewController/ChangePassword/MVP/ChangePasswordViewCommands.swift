//
//  ChangePasswordViewCommands.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 19.11.23.
//

import Foundation

protocol ChangePasswordViewCommands: AnyObject {
    func clearAllPasswordFields()
    func clearNewPasswordFields()
    func dismissModal()
    func hideActivityIndicator()
    func hideBlurView()
    func setCancelButtonEnabled(_ enabled: Bool)
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
