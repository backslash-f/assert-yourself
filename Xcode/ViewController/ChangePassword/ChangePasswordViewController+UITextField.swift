//
//  ChangePasswordViewController+UITextField.swift
//  RefactoringTests
//
//  Created by Fernando Fernandes on 18.11.23.
//

import Foundation
import UIKit

extension ChangePasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === oldPasswordTextField {
            updateInputFocus(.newPassword)
        } else if textField === newPasswordTextField {
            updateInputFocus(.confirmPassword)
        } else if textField === confirmPasswordTextField {
            changePassword()
        }
        return true
    }
}
