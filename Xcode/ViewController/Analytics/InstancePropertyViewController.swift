//
//  InstancePropertyViewController.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 17.08.23.
//

import UIKit

class InstancePropertyViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Analytics.shared.track(event: "viewDidAppear - \(type(of: self))")
    }
}
