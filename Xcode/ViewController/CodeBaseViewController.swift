//
//  CodeBaseViewController.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 16.08.23.
//

import UIKit

class CodeBaseViewController: UIViewController {
    private let data: String

    init(data: String) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(">> create views here")
    }
}
