//
//  AppDelegate.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 03.08.23.
//

import UIKit

@objc(TestAppDelegate)
class TestAppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        print(">> Launching with testing app delegate")
        return true
    }
}
