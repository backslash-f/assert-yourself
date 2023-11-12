//
//  TableViewController.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 12.11.23.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    private let model = [
        "One",
        "Two",
        "Three"
    ]

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        model.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )

        cell.textLabel?.text = model[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        print(">> \(model[indexPath.row])")
    }
}
