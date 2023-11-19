//
//  ChangePasswordPresenter.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 19.11.23.
//

import Foundation

class ChangePasswordPresenter {
    unowned var view: ChangePasswordViewCommands!

    var viewModel: ChangePasswordViewModel

    let securityToken: String
    let passwordChanger: PasswordChanging

    init(view: ChangePasswordViewCommands,
         viewModel: ChangePasswordViewModel,
         securityToken: String,
         passwordChanger: PasswordChanging) {
        self.view = view
        self.viewModel = viewModel
        self.securityToken = securityToken
        self.passwordChanger = passwordChanger
    }
}
