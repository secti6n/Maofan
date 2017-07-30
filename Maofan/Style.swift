//
//  Style.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/31.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import UIKit

class Style {
    
    static var onePixel: CGFloat {
        return 1 / UIScreen.main.scale
    }
    
    static var linkFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
    }
    
    static var nameFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
    }
    
    static var plainFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
    }
    
    static var metaFont: UIFont {
        return UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.regular)
    }
    
    static var plainColor: UIColor {
        return UIColor(hex: "000000")
    }
    
    static var tintColor: UIColor {
        return UIColor(hex: "10adff")
    }
    
    static var metaColor: UIColor {
        return UIColor(hex: "ced4e0")
    }
    
    static var backgroundColor: UIColor {
        return UIColor(hex: "FFFFFF")
    }
    
    static var barColor: UIColor {
        return backgroundColor
    }
    
    static var borderColor: UIColor {
        return plainColor.alpha(0.08)
    }
    
    static var unSelect: UIColor {
        return metaColor
    }
    
    static func image(_ tintColor: UIColor, pixel: Bool = false) -> UIImage {
        let length = pixel ? 1 / UIScreen.main.scale : 1
        let size = CGSize(width: length, height: length)
        return image(tintColor: tintColor, size: size)
    }
    
    static func image(tintColor: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        tintColor.setFill()
        context.fill(CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
