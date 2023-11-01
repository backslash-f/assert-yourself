//
//  TestError.swift
//  NetworkResponseTests
//
//  Created by Fernando Fernandes on 27.08.23.
//

import Foundation

struct TestError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}
