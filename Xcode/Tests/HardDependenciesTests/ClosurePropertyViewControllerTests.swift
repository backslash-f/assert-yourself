//
//  ClosurePropertyViewControllerTests.swift
//  HardDependenciesTests
//
//  Created by Fernando Fernandes on 18.08.23.
//

import XCTest

@testable import AssertYourself

final class ClosurePropertyViewControllerTests: XCTestCase {

    func test_viewDidAppear() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: ClosurePropertyViewController = storyboard
            .instantiateViewController(
                withIdentifier: String(
                    describing: ClosurePropertyViewController.self
                )
            ) as! ClosurePropertyViewController
        sut.loadViewIfNeeded()

        sut.makeAnalytics = { Analytics() }
        sut.loadViewIfNeeded()

        sut.viewDidAppear(false)

        // Normally, assert something.
    }
}
