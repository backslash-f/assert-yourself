//
//  ButtonTapsTests.swift
//  ButtonTapsTests
//
//  Created by Fernando Fernandes on 16.10.23.
//

import XCTest

@testable import AssertYourself

final class ButonTapsTests: XCTestCase {

    func test_tappingButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: ViewController = storyboard.instantiateViewController(
            withIdentifier: String(describing: ViewController.self)
        ) as! ViewController
        sut.loadViewIfNeeded()

        tap(sut.tapsButton)
    }
}
