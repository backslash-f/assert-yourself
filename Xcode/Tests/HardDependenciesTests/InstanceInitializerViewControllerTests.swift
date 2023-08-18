//
//  InstanceInitializerViewControllerTests.swift
//  HardDependenciesTests
//
//  Created by Fernando Fernandes on 18.08.23.
//

import XCTest

@testable import AssertYourself

final class InstanceInitializerViewControllerTests: XCTestCase {

    func test_viewDidAppear() {
        let sut = InstanceInitializerViewController(analytics: Analytics())
        sut.loadViewIfNeeded()

        sut.viewDidAppear(false)

        // Normally, assert something.
    }
}
