//
//  UIButtonExtension.swift
//  TesteAndre
//
//  Created by André Henrique da Silva on 15/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    class func actionButton(_ image: UIImage) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(image, for: UIControlState())
        return button
    }
    
    class func fancyButton(title: String, image: UIImage, backgroundColor: UIColor = UIColor.clear, titleColor: UIColor = UIColor.middleHighlightColor(), fakeShadowColor: UIColor = UIColor.shadowColor()) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(image, for: UIControlState())
        button.setTitle(title, for: UIControlState())
        button.titleLabel?.font = Font.proximaNovaBold16
        button.backgroundColor = backgroundColor
        button.setTitleColor(titleColor, for: UIControlState())
        button.imageEdgeInsets = UIEdgeInsetsMake(0.0, -10.0, 0.0, 0.0)
        
        let fakeShadowView = UIView(frame: CGRect(x: 0.0, y: 37.0, width: 1000.0, height: 3.0))
        fakeShadowView.backgroundColor = fakeShadowColor
        
        button.addSubview(fakeShadowView)

        button.layer.cornerRadius = 2.0
        button.layer.masksToBounds = true
        button.layer.borderColor =  (backgroundColor == UIColor.clear) ? UIColor.shadowColor().cgColor : titleColor.cgColor
        button.layer.borderWidth = 1.0
    
        return button
    }

}
