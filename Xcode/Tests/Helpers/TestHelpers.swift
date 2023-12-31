//
//  TestHelpers.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 25.10.23.
//

import UIKit
import XCTest

func verifyMethodCalledOnce(methodName: String,
                            callCount: Int,
                            describeArguments: @autoclosure () -> String,
                            file: StaticString = #file,
                            line: UInt = #line) -> Bool {
    if callCount == 0 {
        XCTFail("Wanted but not invoked: \(methodName)",
                file: file, line: line)
        return false
    }

    if callCount > 1 {
        XCTFail("Wanted 1 time but was called \(callCount) times. " + "\(methodName) with \(describeArguments())",
                file: file, line: line)
        return false
    }

    return true
}

func verifyMethodNeverCalled(methodName: String,
                             callCount: Int,
                             describeArguments: @autoclosure () -> String,
                             file: StaticString = #file,
                             line: UInt = #line) {
    let times = callCount == 1 ? "time" : "times"

    if callCount > 0 {
        XCTFail("Never wanted but was called \(callCount) \(times). " + "\(methodName) with \(describeArguments())",
                file: file,
                line: line
        )
    }
}
