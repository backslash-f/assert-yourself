//
//  Analytics.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 17.08.23.
//

import Foundation

class Analytics {
    static let shared = Analytics()

    func track(event: String) {
        print(">> " + event)

        if self !== Analytics.shared {
            print(">> Not the Analytics singleton")
        }
    }
}
