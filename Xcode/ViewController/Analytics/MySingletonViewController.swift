//
//  MySingletonViewController.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 17.08.23.
//

import UIKit

class MySingletonViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MySingletonAnalytics.shared.track(event: "viewDidAppear - \(type(of: self))")
    }
}
