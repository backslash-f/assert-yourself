//
//  NavigationTests.swift
//  NavigationTests
//
//  Created by Fernando Fernandes on 01.11.23.
//

import XCTest

@testable import AssertYourself

final class NavigationTests: XCTestCase {

    func test_tappingCodePushButton_shouldPushCodeNextViewController() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: ViewController = storyboard.instantiateViewController(
            withIdentifier: String(describing: ViewController.self)
        ) as! ViewController
        sut.loadViewIfNeeded()
        let navigation = UINavigationController(rootViewController: sut)

        tap(sut.codePushButton)
        
        executeRunLoop()

        XCTAssertNotNil(sut.navigationController)
        XCTAssertEqual(navigation.viewControllers.count, 2, "navigation stack")

        let pushedVC = navigation.viewControllers.last
        guard let codeNextVC = pushedVC as? CodeNextViewController else {
            XCTFail("Expected CodeNextViewController, "
                    + "but was \(String(describing: pushedVC))"
            )
            return
        }
        XCTAssertEqual(codeNextVC.label.text, "Pushed from code")
    }
}
