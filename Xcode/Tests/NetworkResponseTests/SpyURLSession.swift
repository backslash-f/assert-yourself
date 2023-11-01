//
//  SpyURLSession.swift
//  NetworkResponseTests
//
//  Created by Fernando Fernandes on 27.08.23.
//

import Foundation
import XCTest

@testable import AssertYourself

class SpyURLSession {
    var dataForRequestCallCount = 0
    var dataForRequestArgsRequest: [URLRequest] = []

    var error: Error?
    var data: Data?

    private var response: URLResponse?

    // MARK: - Lifecycle

    init(error: Error? = nil,
         data: Data? = nil,
         responseStatusCode: Int? = nil) {
        self.error = error
        self.data = data

        if let responseStatusCode {
            self.response = response(statusCode: responseStatusCode)
        }
    }
}

// MARK: - URLSessionProtocol

extension SpyURLSession: URLSessionProtocol {
    func data(for request: URLRequest,
              delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        dataForRequestCallCount += 1
        dataForRequestArgsRequest.append(request)

        if let error { throw error }

        return (data ?? Data(), response ?? URLResponse())
    }
}

// MARK: - Private

private extension SpyURLSession {
    func response(statusCode: Int) -> HTTPURLResponse? {
        HTTPURLResponse(
            url: URL(string: "http://SpyURLSession")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
    }
}
