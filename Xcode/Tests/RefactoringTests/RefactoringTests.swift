//
//  RefactoringTests.swift
//  RefactoringTests
//
//  Created by Fernando Fernandes on 14.11.23.
//

import XCTest

@testable import AssertYourself

final class RefactoringTests: XCTestCase {

    private var sut: ChangePasswordViewController!

    @MainActor
    override func setUp() {
        super.setUp()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: ChangePasswordViewController.self)
        sut = sb.instantiateViewController(identifier: identifier)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_zero() throws {
        XCTAssertNotNil(sut)
    }
}
