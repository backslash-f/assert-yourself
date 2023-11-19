//
//  ChangePasswordPresenter.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 19.11.23.
//

import Foundation

class ChangePasswordPresenter {
    unowned var view: ChangePasswordViewCommands!

    var labels: ChangePasswordLabels

    let securityToken: String
    let passwordChanger: PasswordChanging

    init(view: ChangePasswordViewCommands,
         labels: ChangePasswordLabels,
         securityToken: String,
         passwordChanger: PasswordChanging) {
        self.view = view
        self.labels = labels
        self.securityToken = securityToken
        self.passwordChanger = passwordChanger
    }
}
