//
//  NavigationTests.swift
//  NavigationTests
//
//  Created by Fernando Fernandes on 01.11.23.
//

import ViewControllerPresentationSpy
import XCTest

@testable import AssertYourself

final class NavigationTests: XCTestCase {

    private var sut: ViewController!

    @MainActor
    override func setUp() {
        super.setUp()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        sut = sb.instantiateViewController(
            identifier: String(describing: ViewController.self)
        ) as? ViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        executeRunLoop()
        sut = nil
        super.tearDown()
    }

    func test_tappingCodePushButton_shouldPushCodeNextViewController() throws {
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

    func test_INCORRECT_tappingCodeModalButton_shouldPresentCodeNextViewController() {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows
            .first?
            .rootViewController = sut

        tap(sut.codeModalButton)

        let presentedVC = sut.presentedViewController
        guard let codeNextVC = presentedVC as? CodeNextViewController else {
            XCTFail("Expected CodeNextViewController, "
                    + "but was \(String(describing: presentedVC))")
            return
        }
        XCTAssertEqual(codeNextVC.label.text, "Modal from code")
    }

    @MainActor
    func test_tappingCodeModalButton_shouldPresentCodeNextViewController() {
        let presentationVerifier = PresentationVerifier()

        tap(sut.codeModalButton)

        let codeNextVC: CodeNextViewController? = presentationVerifier.verify(
            animated: true,
            presentingViewController: sut
        )
        XCTAssertEqual(codeNextVC?.label.text, "Modal from code")
    }

    @MainActor
    func test_tappingSeguePushButton_shouldShowSegueNextViewController() {
        let presentationVerifier = PresentationVerifier()

        putInWindow(sut)

        tap(sut.seguePushButton)

        let segueNextVC: SegueNextViewController? = presentationVerifier.verify(
            animated: true,
            presentingViewController: sut
        )

        XCTAssertEqual(segueNextVC?.labelText, "Pushed from segue")
    }
}

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
