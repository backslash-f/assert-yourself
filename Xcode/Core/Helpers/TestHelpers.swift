//
//  TestHelpers.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 25.10.23.
//

import UIKit

func tap(_ button: UIButton) {
    button.sendActions(for: .touchUpInside)
}

func tap(_ button: UIBarButtonItem) {
    _ = button.target?.perform(button.action, with: nil)
}
