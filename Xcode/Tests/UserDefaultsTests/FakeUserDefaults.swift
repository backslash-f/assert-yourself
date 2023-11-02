//
//  FakeUserDefaults.swift
//  UserDefaultsTests
//
//  Created by Fernando Fernandes on 02.11.23.
//

import Foundation

@testable import AssertYourself

class FakeUserDefaults: UserDefaultsProtocol {
    var integers: [String: Int] = [:]

    func set(_ value: Int, forKey defaultName: String) {
        integers[defaultName] = value
    }

    func integer(forKey defaultName: String) -> Int {
        integers[defaultName] ?? 0
    }
}
