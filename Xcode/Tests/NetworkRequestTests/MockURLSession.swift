//
//  MockURLSession.swift
//  NetworkRequestTests
//
//  Created by Fernando Fernandes on 22.08.23.
//

import Foundation

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
}
