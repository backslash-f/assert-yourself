//
//  ChangePasswordViewController+Commands.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 19.11.23.
//

import Foundation
import UIKit

extension ChangePasswordViewController: ChangePasswordViewCommands {
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }

    func showActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
}
