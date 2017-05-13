//
//  Style.swift
//  Maofan
//
//  Created by Catt Liu on 2016/12/31.
//  Copyright © 2016年 Catt Liu. All rights reserved.
//

import UIKit

class Style {
    
    static var linkFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
    }
    
    static var nameFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
    }
    
    static var plainFont: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: UIFontWeightRegular)
    }
    
    static var metaFont: UIFont {
        return UIFont.systemFont(ofSize: 10, weight: UIFontWeightRegular)
    }
    
    static var plainColor: UIColor {
        return UIColor(hex: "000000")
    }
    
    static var highlightColor: UIColor {
        return UIColor(hex: "0FB7FF")
    }
    
    static var metaColor: UIColor {
        return UIColor(hex: "CFD6DC")
    }
    
    static var backgroundColor: UIColor {
        return UIColor(hex: "FFFFFF")
    }
    
    static var blurBarColor: UIColor {
        return backgroundColor.alpha(0.9)
    }
    
    static var border: UIColor {
        return plainColor.alpha(0.1)
    }
    
    static var unSelect: UIColor {
        return plainColor.alpha(0.05)
    }
    
    static func image(_ tintColor: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
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
