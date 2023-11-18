//
//  ChangePasswordViewController+Alert.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 18.11.23.
//

import Foundation
import UIKit

extension ChangePasswordViewController {
    func showAlert(message: String, okAction: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert)

        let okButton = UIAlertAction(
            title: viewModel.okButtonLabel,
            style: .default,
            handler: okAction
        )

        alertController.addAction(okButton)
        alertController.preferredAction = okButton
        present(alertController, animated: true)
    }
}
