//
//  LifeCycleTests.swift
//  LifeCycleTests
//
//  Created by Fernando Fernandes on 04.08.23.
//

import XCTest

@testable import AssertYourself

final class LifeCycleTests: XCTestCase {

    private var sut: MyClass!

    override func setUp() {
        super.setUp()
        sut = MyClass()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_methodOne() {
        sut.methodOne()
        
        // Normally, assert something
    }

    func test_methodTwo() {
        sut.methodTwo()

        // Normally, assert something
    }
}
