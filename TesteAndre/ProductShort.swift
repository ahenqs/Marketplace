//
//  ProductShort.swift
//  TesteAndre
//
//  Created by André Henrique da Silva on 14/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation

struct ProductShort {
    
    var discountPercentage: Int
    var id: Int
    var originalPrice: Int
    var price: Int
    var title: String
    var content: String
    var likesCount: Int
    var defaultPhoto: String
    var productURL: String
    
    init(discountPercentage: Int, id: Int, originalPrice: Int, price: Int, title: String, content: String, likesCount: Int, defaultPhoto: String) {
        self.discountPercentage = discountPercentage
        self.id = id
        self.originalPrice = originalPrice
        self.price = price
        self.title = title
        self.content = content
        self.likesCount = likesCount
        self.defaultPhoto = defaultPhoto
        self.productURL = ""
    }
    
    
}

extension ProductShort: JSONDecodable {
    
    init(JSON: [String: AnyObject]) {
        
        if let discountP = JSON["discount_percentage"] as? Int {
            self.discountPercentage = discountP
        } else {
            self.discountPercentage = 0
        }
        
        if let key = JSON["id"] as? Int {
            self.id = key
        } else {
            self.id = 0
        }
        
        if let originalP = JSON["original_price"] as? Int {
            self.originalPrice = originalP
        } else {
            self.originalPrice = 0
        }
        
        if let p = JSON["price"] as? Int {
            self.price = p
        } else {
            self.price = 0
        }
        
        if let t = JSON["title"] as? String {
            self.title = t
        } else {
            self.title = ""
        }
        
        if let c = JSON["content"] as? String {
            self.content = c
        } else {
            self.content = ""
        }
        
        if let likes = JSON["likes_count"] as? Int {
            self.likesCount = likes
        } else {
            self.likesCount = 0
        }
        
        if let defaultP = JSON["default_photo"] as? String {
            self.defaultPhoto = defaultP
        } else {
            self.defaultPhoto = ""
        }
        
        self.productURL = ""
    }
}
