//
//  TestHelpers.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 23.08.23.
//

import XCTest

func tap(_ button: UIButton) {
    button.sendActions(for: .touchUpInside)
}
