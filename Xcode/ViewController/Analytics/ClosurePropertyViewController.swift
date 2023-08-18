//
//  ClosurePropertyViewController.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 17.08.23.
//

import UIKit

class ClosurePropertyViewController: UIViewController {

    var makeAnalytics: () -> Analytics = { Analytics.shared }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeAnalytics().track(event: "viewDidAppear - \(type(of: self))")
    }
}
