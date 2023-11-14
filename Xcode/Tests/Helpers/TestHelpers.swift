//
//  TestHelpers.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 25.10.23.
//

import UIKit
import XCTest

// MARK: - UIKit

func executeRunLoop() {
    RunLoop.current.run(until: Date())
}

func putInViewHierarchy(_ vc: UIViewController) {
    let window = UIWindow()
    window.addSubview(vc.view)
}

func putInWindow(_ vc: UIViewController) {
    let window = UIWindow()
    window.rootViewController = vc
    window.isHidden = false
}

// MARK: UIButton

func tap(_ button: UIButton) {
    button.sendActions(for: .touchUpInside)
}

func tap(_ button: UIBarButtonItem) {
    _ = button.target?.perform(button.action, with: nil)
}

// MARK: UITextField

extension UITextContentType: CustomStringConvertible {
    public var description: String { rawValue }
}

extension UITextAutocorrectionType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .default:
            return "default"
        case .no:
            return "no"
        case .yes:
            return "yes"
        @unknown default:
            fatalError("Unknown UITextAutocorrectionType")
        }
    }
}

extension UIReturnKeyType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .default:
            return "default"
        case .go:
            return "go"
        case .google:
            return "google"
        case .join:
            return "join"
        case .next:
            return "next"
        case .route:
            return "route"
        case .search:
            return "search"
        case .send:
            return "send"
        case .yahoo:
            return "yahoo"
        case .done:
            return "done"
        case .emergencyCall:
            return "emergencyCall"
        case .continue:
            return "continue"
        @unknown default:
            fatalError("Unknown UITextAutocorrectionType")
        }
    }
}

func shouldChangeCharacters(in textField: UITextField,
                            range: NSRange = NSRange(),
                            replacement: String) -> Bool? {
    textField.delegate?.textField?(
        textField,
        shouldChangeCharactersIn: range,
        replacementString: replacement
    )
}

@discardableResult
func shouldReturn(in textField: UITextField) -> Bool? {
    textField.delegate?.textFieldShouldReturn?(textField)
}

// MARK: UITableView

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

// MARK: - Method Verifier

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
