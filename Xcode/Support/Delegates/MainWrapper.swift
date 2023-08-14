//
//  Main.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 14.08.23.
//

import Foundation
import UIKit

@main
struct MainWrapper {
    static func main() {
        UIApplicationMain(
            CommandLine.argc,
            CommandLine.unsafeArgv,
            nil,
            NSStringFromClass(appDelegateClass())
        )
    }
}

// MARK: - Private

private extension MainWrapper {
    static func appDelegateClass() -> AnyClass {
        NSClassFromString("TestAppDelegate") ?? AppDelegate.self
    }
}
