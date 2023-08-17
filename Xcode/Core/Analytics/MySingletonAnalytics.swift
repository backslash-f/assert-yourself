//
//  MySingletonAnalytics.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 17.08.23.
//

import Foundation

class MySingletonAnalytics {
    static let shared = MySingletonAnalytics()

    func track(event: String) {
        Analytics.shared.track(event: event)

        if self !== MySingletonAnalytics.shared {
            print(">> Not the MySingletonAnalytics singleton")
        }
    }
}
