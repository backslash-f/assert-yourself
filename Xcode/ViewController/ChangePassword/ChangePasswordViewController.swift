//
//  ChangePasswordViewController.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 14.11.23.
//

import Foundation
import UIKit

class ChangePasswordViewController: UIViewController {
    @IBOutlet private(set) var navigationBar: UINavigationBar!
    @IBOutlet private(set) var cancelBarButton: UIBarButtonItem!
    @IBOutlet private(set) var oldPasswordTextField: UITextField!
    @IBOutlet private(set) var newPasswordTextField: UITextField!
    @IBOutlet private(set) var confirmPasswordTextField: UITextField!
    @IBOutlet private(set) var submitButton: UIButton!

    var securityToken = ""

    let activityIndicator = UIActivityIndicatorView(style: .large)
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let labels = ChangePasswordLabels()

    lazy var passwordChanger: PasswordChanging = PasswordChanger()

    lazy var presenter = ChangePasswordPresenter(
        view: self,
        labels: labels,
        securityToken: securityToken,
        passwordChanger: passwordChanger
    )

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        setupSubmitButton()
        setupBlurView()
        setupActivityIndicator()
    }

    // MARK: - IBActions

    @IBAction private func cancel() {
        presenter.cancel()
    }

    @IBAction func changePassword() {
        presenter.changePassword(
            passwordInputs: .init(
                oldPassword: oldPasswordTextField.text ?? "",
                newPassword: newPasswordTextField.text ?? "",
                confirmPassword: confirmPasswordTextField.text ?? ""
            )
        )
    }
}
