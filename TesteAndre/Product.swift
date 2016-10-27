//
//  Product.swift
//  TesteAndre
//
//  Created by André Henrique da Silva on 15/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation

struct Product {
    
    var discountPercentage: Int
    var condition: String
    var photos: [String]?
    var id: Int
    var originalPrice: Float
    var price: Float
    var size: String?
    var shippingType: String
    var title: String
    var content: String
    var brand: String
    var likesCount: Int
    var userTitle: String
    var userCity: String
    var userState: String
    var relatedProducts: [ProductShort]?
    var productURL: String
    
    init() {
        self.discountPercentage = 0
        self.condition = ""
        self.photos = nil
        self.id = 0
        self.originalPrice = 0.0
        self.price = 0.0
        self.size = nil
        self.shippingType = ""
        self.title = ""
        self.content = ""
        self.brand = ""
        self.likesCount = 0
        self.userTitle = ""
        self.userCity = ""
        self.userState = ""
        self.relatedProducts = nil
        self.productURL = ""
    }
}

extension Product: JSONDecodable {
    
    init(JSON: [String: AnyObject]) {
        
        if let discountP = JSON["discount_percentage"] as? Int {
            self.discountPercentage = discountP
        } else {
            self.discountPercentage = 0
        }
        
        if let condition = JSON["condition"] as? String {
            self.condition = condition
        } else {
            self.condition = ""
        }
        
        if let photos = JSON["photos"] as? [String] {
            self.photos = photos
        } else {
            self.photos = []
        }
        
        if let key = JSON["id"] as? Int {
            self.id = key
        } else {
            self.id = 0
        }
        
        if let originalP = JSON["original_price"] as? Float {
            self.originalPrice = originalP
        } else {
            self.originalPrice = 0.0
        }
        
        if let p = JSON["price"] as? Float {
            self.price = p
        } else {
            self.price = 0.0
        }
        
        if let size = JSON["size"] as? String {
            self.size = size
        } else {
            self.size = ""
        }
        
        if let shipping = JSON["shipping_type"] as? String {
            self.shippingType = shipping
        } else {
            self.shippingType = ""
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
        
        if let brand = JSON["brand"] as? String {
            self.brand = brand
        } else {
            self.brand = ""
        }
        
        if let likes = JSON["likes_count"] as? Int {
            self.likesCount = likes
        } else {
            self.likesCount = 0
        }
        
        if let userTitle = JSON["user_title"] as? String {
            self.userTitle = userTitle
        } else {
            self.userTitle = ""
        }
        
        if let userCity = JSON["user_city"] as? String {
            self.userCity = userCity
        } else {
            self.userCity = ""
        }
        
        if let userState = JSON["user_state"] as? String {
            self.userState = userState
        } else {
            self.userState = ""
        }
        
        if let relatedProds = JSON["related_products"] as? [[String: AnyObject]] {
            
            var prods = [ProductShort]()
            
            for p in relatedProds {
                
                let prod = ProductShort(JSON: p)
                
                prods.append(prod)
            }
            
            self.relatedProducts = prods
            
        } else {
            self.relatedProducts = [ProductShort]()
        }
        
        self.productURL = ""
        
    }
}