//
//  MockURLSession.swift
//  NetworkRequestTests
//
//  Created by Fernando Fernandes on 22.08.23.
//

import Foundation
import XCTest

@testable import AssertYourself

class MockURLSession: URLSessionProtocol {
    var dataForRequestCallCount = 0
    var dataForRequestArgsRequest: [URLRequest] = []

    func data(for request: URLRequest,
              delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        dataForRequestCallCount += 1
        dataForRequestArgsRequest.append(request)

        return (Data(), URLResponse())
    }

    func verifyDataTask(with request: URLRequest,
                        file: StaticString = #file,
                        line: UInt = #line) {
        guard dataTaskWasCalledOnce(file: file, line: line) else {
            return
        }
        XCTAssertEqual(
            dataForRequestArgsRequest.first,
            request, "request",
            file: file,
            line: line
        )
    }
}

// MARK: - Private

private extension MockURLSession {
    func dataTaskWasCalledOnce(
        file: StaticString = #file,
        line: UInt = #line) -> Bool {
            verifyMethodCalledOnce(
                methodName: "data(for:delegate:)",
                callCount: dataForRequestCallCount,
                describeArguments: "request: \(dataForRequestCallCount)",
                file: file,
                line: line
            )
    }
}
