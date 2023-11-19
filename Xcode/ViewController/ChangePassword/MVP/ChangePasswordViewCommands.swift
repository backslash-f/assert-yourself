//
//  ChangePasswordViewCommands.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 19.11.23.
//

import Foundation

protocol ChangePasswordViewCommands: AnyObject {
    func dismissModal()
    func hideActivityIndicator()
    func showActivityIndicator()
    func showAlert(message: String, action: @escaping () -> Void)
}