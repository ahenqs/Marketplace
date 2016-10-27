//
//  ProductCell.swift
//  TesteAndre
//
//  Created by André Henrique da Silva on 14/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell {
    
    var product: ProductShort? {
        didSet {
            titleLabel.text = product!.title
            priceLabel.text = product!.price.toCurrency()
            likeButton.setTitle(String(product!.likesCount), for: UIControlState())
            
            photoImageView.loadImageUsingCacheWithUrlString(product!.defaultPhoto)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.lightColor()
        return imageView
    }()
    
    let detailContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.backgroundColor()
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.proximaNovaLight16
        label.textColor = UIColor.mainColor()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Font.proximaNovaRegular14
        label.textColor = UIColor.highlightColor()
        label.textAlignment = .center
        return label
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15.0
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.lightColor()
        return imageView
    }()
    
    lazy var userButton: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Like"), for: UIControlState())
        button.titleLabel?.font = Font.proximaNovaLight14
        button.setTitleColor(UIColor.lightColor(), for: UIControlState())
        button.imageEdgeInsets = UIEdgeInsetsMake(4.0, -10.0, 0.0, 0.0)
        return button
    }()
    
    let horizontalSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkBackgroundColor()
        return view
    }()
    
    let verticalSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkBackgroundColor()
        return view
    }()
    
    func setupViews() {
        
        self.backgroundColor = UIColor.lightBackgroundColor()
        
        addSubview(photoImageView)
        
        detailContentView.addSubview(titleLabel)
        detailContentView.addSubview(priceLabel)
        detailContentView.addSubview(horizontalSeparatorView)
        detailContentView.addSubview(verticalSeparatorView)
        detailContentView.addSubview(userImageView)
        detailContentView.addSubview(userButton)
        detailContentView.addSubview(likeButton)
        
        addSubview(detailContentView)
        
        addConstraintWithFormat("H:|[v0]|", views: photoImageView)
        addConstraintWithFormat("H:|[v0]|", views: detailContentView)
        addConstraintWithFormat("V:|[v0(206)][v1(108)]-3-|", views: photoImageView, detailContentView)
        
        detailContentView.addConstraintWithFormat("H:|-[v0]-|", views: titleLabel)
        detailContentView.addConstraintWithFormat("H:|-[v0]-|", views: priceLabel)
        detailContentView.addConstraintWithFormat("H:|[v0]|", views: horizontalSeparatorView)
        detailContentView.addConstraintWithFormat("H:|[v0][v1(0.5)][v2(==v0)]|", views: userButton, verticalSeparatorView, likeButton)
        detailContentView.addConstraintWithFormat("V:|-[v0]-[v1]-10-[v2(0.5)][v3(48)]", views: titleLabel, priceLabel, horizontalSeparatorView, userButton)
        detailContentView.addConstraintWithFormat("V:[v0(0.5)][v1(==v2)]", views: horizontalSeparatorView, likeButton, userButton)
        detailContentView.addConstraintWithFormat("V:[v0(0.5)][v1(==v2)]", views: horizontalSeparatorView, verticalSeparatorView, userButton)
        
        detailContentView.addConstraintWithFormat("H:[v0(30)]", views: userImageView)
        detailContentView.addConstraintWithFormat("V:[v0(30)]", views: userImageView)
        
        let userImageViewXConstraint = NSLayoutConstraint(item: userImageView, attribute: .centerX, relatedBy: .equal, toItem: userButton, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        let userImageViewYConstraint = NSLayoutConstraint(item: userImageView, attribute: .centerY, relatedBy: .equal, toItem: userButton, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        detailContentView.addConstraints([userImageViewXConstraint, userImageViewYConstraint])
        
        //rounded corners
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
        
        
    }
}
