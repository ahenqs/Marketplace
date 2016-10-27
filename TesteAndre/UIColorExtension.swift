//
//  UIColorExtension.swift
//  TesteAndre
//
//  Created by André Henrique da Silva on 14/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    // MARK: Background Color
    
    public static func backgroundColor() -> UIColor {
        return rgb(red: 255, green: 255, blue: 255)
    }
    
    public static func darkBackgroundColor() -> UIColor {
        return rgb(red: 244, green: 242, blue: 240)
    }
    
    public static func lightBackgroundColor() -> UIColor {
        return rgb(red: 237, green: 235, blue: 233)
    }
    
    // MARK: Gray Color family
    public static func navigationBarTitleColor() -> UIColor {
        return rgb(red: 91, green: 85, blue: 85)
    }
    
    public static func mainColor() -> UIColor {
        return rgb(red: 125, green: 122, blue: 119)
    }
    
    public static func darkColor() -> UIColor {
        return rgb(red: 91, green: 88, blue: 85)
    }
    
    public static func lightColor() -> UIColor {
        return rgb(red: 202, green: 197, blue: 191)
    }
    
    public static func shadowColor() -> UIColor {
        return rgb(red: 237, green: 234, blue: 232)
    }
    
    // MARK: Pink Color family
    
    public static func highlightColor() -> UIColor {
        return rgb(red: 249, green: 113, blue: 113)
    }
    
    public static func darkHighlightColor() -> UIColor {
        return rgb(red: 232, green: 86, blue: 87)
    }
    
    public static func middleHighlightColor() -> UIColor {
        return rgb(red: 247, green: 114, blue: 116)
    }
    
    public static func highlightShadowColor() -> UIColor {
        return rgb(red: 210, green: 103, blue: 105)
    }
    
    // MARK: Green Color family
    
    public static func highlightActionColor() -> UIColor {
        return rgb(red: 111, green: 207, blue: 103)
    }
}
