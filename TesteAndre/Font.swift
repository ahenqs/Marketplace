//
//  Font.swift
//  TesteAndre
//
//  Created by André Henrique da Silva on 14/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation
import UIKit

private let proximaNovaBold = "ProximaNova-Bold"
private let proximaNovaLight = "ProximaNova-Light"
//private let proximaNovaLightItalic = "ProximaNova-LightIt"
private let proximaNovaRegular = "ProximaNova-Regular"
//private let proximaNovaSemiBold = "ProximaNova-SemiBold"

struct Font {
    
    static let proximaNovaLight14: UIFont = {
        return UIFont(name: proximaNovaLight, size: 14.0)!
    }()
    
    static let proximaNovaLight16: UIFont = {
        return UIFont(name: proximaNovaLight, size: 16.0)!
    }()
    
    static let proximaNovaLight22: UIFont = {
        return UIFont(name: proximaNovaLight, size: 22.0)!
    }()

    static let proximaNovaRegular14: UIFont = {
        return UIFont(name: proximaNovaRegular, size: 14.0)!
    }()

    static let proximaNovaRegular16: UIFont = {
        return UIFont(name: proximaNovaRegular, size: 16.0)!
    }()

    static let proximaNovaBold14: UIFont = {
        return UIFont(name: proximaNovaBold, size: 14.0)!
    }()
    
    static let proximaNovaBold16: UIFont = {
        return UIFont(name: proximaNovaBold, size: 16.0)!
    }()
    
    static let proximaNovaBold18: UIFont = {
        return UIFont(name: proximaNovaBold, size: 18.0)!
    }()
    
    static let proximaNovaBold20: UIFont = {
        return UIFont(name: proximaNovaBold, size: 20.0)!
    }()

    static let proximaNovaBold22: UIFont = {
        return UIFont(name: proximaNovaBold, size: 22.0)!
    }()

}