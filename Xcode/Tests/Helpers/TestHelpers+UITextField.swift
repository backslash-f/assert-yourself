//
//  TestHelpers+UITextField.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 17.11.23.
//

import Foundation
import UIKit

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
