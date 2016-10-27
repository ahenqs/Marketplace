//
//  PhotoViewController.swift
//  TesteAndre
//
//  Created by André Henrique da Silva on 15/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var urlString: String? {
        didSet {
            //Load image from URL
            photoImageview.loadImageUsingCacheWithUrlString(urlString!)
        }
    }
    
    let photoImageview: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        
        view.addSubview(photoImageview)
        
        view.addConstraintWithFormat("H:|[v0]|", views: photoImageview)
        view.addConstraintWithFormat("V:|[v0]|", views: photoImageview)
    }
    
}
