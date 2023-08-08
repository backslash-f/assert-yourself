//
//  CodeCoverage.swift
//  AssertYourself
//
//  Created by Fernando Fernandes on 08.08.23.
//

import Foundation
import UIKit

class CoveredClass {

    static func max(_ x: Int, _ y: Int) -> Int {
        if x < y {
            return y
        } else {
            return x
        }
    }
}
