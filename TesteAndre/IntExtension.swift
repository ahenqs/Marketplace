//
//  IntExtension.swift
//  TesteAndre
//
//  Created by André Henrique da Silva on 15/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation

extension Int {
    
    func toString() -> String {
        return String(self)
    }
    
    func toCurrency() -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        
        let pre = formatter.string(from: NSNumber(value: self))!
        
        //fixes space missing between $ and numbers
        let components = pre.components(separatedBy: "$")
        
        if components.count == 2 {
            
            return "\(components[0])$ \(components[1])"
            
        }
        
        return pre
    }
}
