//
//  ClosureInitializerViewControllerTests.swift
//  HardDependenciesTests
//
//  Created by Fernando Fernandes on 18.08.23.
//

import XCTest

@testable import AssertYourself

final class ClosureInitializerViewControllerTests: XCTestCase {

    func test_viewDidAppear() {
        let sut = ClosureInitializerViewController(makeAnalytics: { Analytics() })
        sut.loadViewIfNeeded()

        sut.viewDidAppear(false)

        // Normally, assert something.
    }
}
