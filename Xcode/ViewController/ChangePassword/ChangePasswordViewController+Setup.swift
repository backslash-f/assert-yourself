//
//  ChangePasswordViewController+Setup.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 18.11.23.
//

import Foundation
import UIKit

extension ChangePasswordViewController {
    func setupLabels() {
        navigationBar.topItem?.title = labels.title
        oldPasswordTextField.placeholder = labels.oldPasswordPlaceholder
        newPasswordTextField.placeholder = labels.newPasswordPlaceholder
        confirmPasswordTextField.placeholder = labels.confirmPasswordPlaceholder
        submitButton.setTitle(labels.submitButtonLabel, for: .normal)
    }

    func setupSubmitButton() {
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor(
            red: 55/255.0,
            green: 147/255.0,
            blue: 251/255.0,
            alpha: 1
        ).cgColor
        submitButton.layer.cornerRadius = 8
    }

    func setupBlurView() {
        blurView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
    }
}
