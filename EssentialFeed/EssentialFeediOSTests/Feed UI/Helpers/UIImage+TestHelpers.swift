//
//  UIImage+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by ChenZhen on 11/12/24.
//

import UIKit

extension UIImage {
    static func make(withColor color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        let imv = UIImageView()
        imv.image = UIImage(data: img!.pngData()!)
        
        return imv.image!
    }
}
