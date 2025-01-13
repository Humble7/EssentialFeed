//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by ChenZhen on 14/1/25.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach({ action in
                (target as NSObject).perform(Selector(action))
            })
        }
    }
}
