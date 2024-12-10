//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by ChenZhen on 11/12/24.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
