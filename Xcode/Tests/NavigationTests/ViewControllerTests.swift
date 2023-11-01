//
//  ViewControllerTests.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 01.11.23.
//

import ViewControllerPresentationSpy
import XCTest

@testable import AssertYourself

// We can't use this for a view controller that comes from a storyboard.
private class TestableViewController: ViewController {
    var presentCallCount = 0
    var presentArgsViewController: [UIViewController] = []
    var presentArgsAnimated: [Bool] = []
    var presentArgsClosure: [(() -> Void)?] = []

    override func present(_ viewControllerToPresent: UIViewController,
                          animated flag: Bool,
                          completion: (() -> Void)? = nil) {
        presentCallCount += 1
        presentArgsViewController.append(viewControllerToPresent)
        presentArgsAnimated.append(flag)
        presentArgsClosure.append(completion)
    }
}
