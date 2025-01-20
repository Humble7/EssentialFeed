//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by ChenZhen on 14/1/25.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
