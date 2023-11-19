//
//  ChangePasswordPresenter.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 19.11.23.
//

import Foundation

class ChangePasswordPresenter {
    private unowned var view: ChangePasswordViewCommands!

    private var viewModel: ChangePasswordViewModel
    private let securityToken: String
    private let passwordChanger: PasswordChanging

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
