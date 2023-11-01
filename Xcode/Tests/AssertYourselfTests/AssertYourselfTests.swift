//
//  AssertYourselfTests.swift
//  AssertYourselfTests
//
//  Created by Fernando Fernandes on 03.08.23.
//

import XCTest
@testable import AssertYourself

final class AssertYourselfTests: XCTestCase {

    func test_fail() {
        XCTFail()
    }

    func test_fail_withSimpleMessage() {
        XCTFail("We have a problem")
    }

    func test_fail_withInterpolatedMessage() {
        let theAnswer = 42
        XCTFail("The Answer to the Great Question is \(theAnswer)")
    }

    func test_assertTrue() {
        let success = false
        XCTAssertTrue(success)
    }

    func test_assertNil() {
        let optionalValue: Int? = 123
        XCTAssertNil(optionalValue)
    }

    struct SimpleStruct {
        let x: Int
        let y: Int
    }

    func test_assertNil_withSimpleStruct() {
        let optionalValue: SimpleStruct? = .init(x: 1, y: 2)
        XCTAssertNil(optionalValue)
    }

    struct SimpleStructWithDescription: CustomStringConvertible {
        let x: Int
        let y: Int

        var description: String { "\(x), \(y)" }
    }

    func test_assertNil_withSelfDescribingType() {
        let optionalValue: SimpleStructWithDescription? = .init(x: 1, y: 2)
        XCTAssertNil(optionalValue)
    }

    func test_assertEqual() {
        let actual = "actual"
        XCTAssertEqual(actual, "expected")
    }

    func test_assertEqual_withOptional() {
        let result: String? = "foo"
        XCTAssertEqual(result, "bar")
    }

    func test_floatingPointDanger() {
        let result = 0.1 + 0.2
        XCTAssertEqual(result, 0.3)
    }

    func test_floatingPointFixed() {
        let result = 0.1 + 0.2
        XCTAssertEqual(result, 0.3, accuracy: 0.0001)
    }

    func test_messageOverkill() {
        let actual = "actual"
        XCTAssertEqual(actual, "expected",
                       "Expected \"expected\" but got \"\(actual)\"")
    }
}
