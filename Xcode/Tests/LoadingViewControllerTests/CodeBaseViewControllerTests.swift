//
//  CodeBaseViewControllerTests.swift
//  AssertYourselfTests
//
//  Created by Fernando Fernandes on 16.08.23.
//

import XCTest

@testable import AssertYourself

final class CodeBaseViewControllerTests: XCTestCase {
    func test_loading() {
        let sut = CodeBaseViewController(data: "DUMMY")
        sut.loadViewIfNeeded()
    }
}
