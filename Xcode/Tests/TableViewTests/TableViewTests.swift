//
//  TableViewTests.swift
//  TableViewTests
//
//  Created by Fernando Fernandes on 12.11.23.
//

import XCTest

@testable import AssertYourself

final class TableViewTests: XCTestCase {

    private var sut: TableViewController!

    @MainActor
    override func setUp() {
        super.setUp()
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: TableViewController.self)
        sut = sb.instantiateViewController(identifier: identifier)
        sut.loadViewIfNeeded()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_tableViewDelegates_shouldBeConnected() throws {
        XCTAssertNotNil(sut.tableView.dataSource, "dataSource")
        XCTAssertNotNil(sut.tableView.delegate, "delegate")
    }

    func test_numberOfRows_shouldBe3() throws {
        XCTAssertEqual(numberOfRows(in: sut.tableView), 3)
    }

    func test_cellForRowAt_withRow0_shouldSetCellLabelToOne() {
        let cell = cellForRow(in: sut.tableView, row: 0)
        XCTAssertEqual(cell?.textLabel?.text, "One")
    }

    func test_cellForRowAt_withRow1_shouldSetCellLabelToTwo() {
        let cell = cellForRow(in: sut.tableView, row: 1)
        XCTAssertEqual(cell?.textLabel?.text, "Two")
    }

    func test_cellForRow_withRow2_shouldSetCellLabelToThree() {
        let cell = cellForRow(in: sut.tableView, row: 2)
        XCTAssertEqual(cell?.textLabel?.text, "Three")
    }

    func test_didSelectRow_withRow1() {
        didSelectRow(in: sut.tableView, row: 1)
        // Normally, assert something
    }
}
