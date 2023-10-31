//
//  AlertTests.swift
//  AlertTests
//
//  Created by Fernando Fernandes on 30.10.23.
//

import ViewControllerPresentationSpy
import XCTest

@testable import AssertYourself

final class AlertTests: XCTestCase {

    private var alertVerifier: AlertVerifier!
    private var sut: ViewController!

    @MainActor
    override func setUp() {
        super.setUp()
        alertVerifier = AlertVerifier()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(
            withIdentifier: String(describing: ViewController.self)
        ) as? ViewController
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        alertVerifier = nil
        sut = nil
        super.tearDown()
    }

    @MainActor
    func test_tappingButton_shouldShowAlert() throws {
        tap(sut.alertButton)

        alertVerifier.verify(
            title: "Do the Thing?",
            message: "Let us know if you want to do the thing.",
            animated: true,
            actions: [
                .cancel("Cancel"),
                .default("OK")
            ],
            presentingViewController: sut
        )

        XCTAssertEqual(
            alertVerifier.preferredAction?.title,
            "OK",
            "preferred action"
        )
    }

    @MainActor
    func test_executeAlertAction_withOKButton() throws {
        tap(sut.alertButton)
        try alertVerifier.executeAction(forButton: "OK")
        // Normally, assert something
    }
}
