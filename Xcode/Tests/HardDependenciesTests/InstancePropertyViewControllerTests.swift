//
//  InstancePropertyViewControllerTests.swift
//  HardDependenciesTests
//
//  Created by Fernando Fernandes on 18.08.23.
//

import XCTest

@testable import AssertYourself

final class InstancePropertyViewControllerTests: XCTestCase {

    func test_viewDidAppear() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sut: InstancePropertyViewController = storyboard
            .instantiateViewController(
                withIdentifier: String(
                    describing: InstancePropertyViewController.self
                )
            ) as! InstancePropertyViewController
        sut.analytics = Analytics()
        sut.loadViewIfNeeded()

        sut.viewDidAppear(false)

        // Normally, assert something.
    }
}
