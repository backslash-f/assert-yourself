//
//  ClosureInitializerViewController.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 17.08.23.
//

import UIKit

class ClosureInitializerViewController: UIViewController {

    private let makeAnalytics: () -> Analytics

    init(makeAnalytics: @escaping () -> Analytics) {
        self.makeAnalytics = makeAnalytics
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        makeAnalytics().track(event: "viewDidAppear - \(type(of: self))")
    }
}
