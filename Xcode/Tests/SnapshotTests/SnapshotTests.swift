//
//  SnapshotTests.swift
//  SnapshotTests
//
//  Created by Fernando Fernandes on 12.11.23.
//

import iOSSnapshotTestCase
import XCTest

@testable import AssertYourself

final class SnapshotTests: FBSnapshotTestCase {

    private var sut: SnapshotsViewController!

    @MainActor
    override func setUp() {
        super.setUp()

        recordMode = false

        let sb = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: SnapshotsViewController.self)
        sut = sb.instantiateViewController(identifier: identifier)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_example() throws {
        FBSnapshotVerifyViewController(sut)
    }
}
