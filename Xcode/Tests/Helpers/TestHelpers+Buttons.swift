//
//  TestHelpers+Buttons.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 17.11.23.
//

import Foundation
import UIKit

func tap(_ button: UIButton) {
    button.sendActions(for: .touchUpInside)
}

func tap(_ button: UIBarButtonItem) {
    _ = button.target?.perform(button.action, with: nil)
}

func systemItem(for barButtonItem: UIBarButtonItem) -> UIBarButtonItem.SystemItem {
    let systemItemNumber = barButtonItem.value(forKey: "systemItem") as! Int
    return UIBarButtonItem.SystemItem(rawValue: systemItemNumber)!
}

extension UIBarButtonItem.SystemItem: CustomStringConvertible {
    public var description: String {
        switch self {
        case .done: return "done"
        case .cancel: return "cancel"
        case .edit: return "edit"
        case .save: return "save"
        case .add: return "add"
        case .flexibleSpace: return "flexibleSpace"
        case .fixedSpace: return "fixedSpace"
        case .compose: return "compose"
        case .reply: return "reply"
        case .action: return "action"
        case .organize: return "organize"
        case .bookmarks: return "bookmarks"
        case .search: return "search"
        case .refresh: return "refresh"
        case .stop: return "stop"
        case .camera: return "camera"
        case .trash: return "trash"
        case .play: return "play"
        case .pause: return "pause"
        case .rewind: return "rewind"
        case .fastForward: return "fastForward"
        case .undo: return "undo"
        case .redo: return "redo"
        case .pageCurl: return "pageCurl"
        case .close: return "close"
        @unknown default: fatalError("Unknown UIBarButtonItem.SystemItem")
        }
    }
}
