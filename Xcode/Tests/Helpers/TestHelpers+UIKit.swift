//
//  TestHelpers+UIKit.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 17.11.23.
//

import Foundation
import UIKit

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
