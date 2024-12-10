//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by ChenZhen on 11/12/24.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
