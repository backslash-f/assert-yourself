//
//  SegueNextViewController.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 01.11.23.
//

import Foundation
import UIKit

class SegueNextViewController: UIViewController {
    @IBOutlet private(set) var label: UILabel!

    var labelText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = labelText
    }

    deinit {
        print(">> SegueNextViewController.deinit")
    }
}
