//
//  ChangePasswordPresenter+WaitingAppearance.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 19.11.23.
//

import Foundation

extension ChangePasswordPresenter {
    func setupWaitingAppearance() {
        view.showBlurView()
        view.updateInputFocus(.noKeyboard)
        view.setCancelButtonEnabled(false)
        view.showActivityIndicator()
    }
}
