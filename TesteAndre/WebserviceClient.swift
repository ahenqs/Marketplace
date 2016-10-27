//
//  WebserviceClient.swift
//  TesteAndre
//
//  Created by André Henrique da Silva on 16/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import Foundation

enum ProductEndpoint: Endpoint {
    
    case list
    case detail(pathString: String)
    
    var baseURL: String {
        return "https://gist.githubusercontent.com"
    }
    
    var path: String {
        switch self {
        case .list:
            return "/caironoleto/9cd18d9642a7d5e8eef0/raw/dbe726570f063e2be2b353fd35d48ff9f9180b52/_products.json"
        case .detail(let pathString):
            return pathString
        }
    }
    
}

final class WebserviceClient: APIClient {
    let configuration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.configuration)
    }()
    
    init(configuration: URLSessionConfiguration) {
        self.configuration = configuration
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func fetchProductsList(_ completionHandler: @escaping (APIResult<[ProductShort]>) -> Void) {
        let request = ProductEndpoint.list.request
        
        fetch(request, parse: { json -> [ProductShort]? in
            
            guard let products = json["products"] as? [[String: AnyObject]] else {
                return nil
            }
            
            return products.flatMap { peepDict in
                return ProductShort(JSON: peepDict)
            }
            
            }, completionHandler: completionHandler)
    }
    
    func fetchProduct(_ path: String, completionHandler: @escaping (APIResult<Product>) -> Void) {
        
        let request = ProductEndpoint.detail(pathString: path).request
        
        fetch(request, parse: { json -> Product? in
            
            let p = Product(JSON: json)
            
            return p
            
            }, completionHandler: completionHandler)
    }
    
}
