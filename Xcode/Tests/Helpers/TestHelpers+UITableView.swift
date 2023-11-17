//
//  TestHelpers+UITableView.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 17.11.23.
//

import Foundation
import UIKit

func numberOfRows(in tableView: UITableView, section: Int = 0) -> Int? {
    tableView.dataSource?.tableView(
        tableView,
        numberOfRowsInSection: section
    )
}

func cellForRow(in tableView: UITableView, row: Int, section: Int = 0) -> UITableViewCell? {
    let indexPath = IndexPath(row: row, section: section)
    return tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
}

func didSelectRow(in tableView: UITableView, row: Int, section: Int = 0) {
    let indexPath = IndexPath(row: row, section: section)
    tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
}
