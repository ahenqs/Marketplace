//
//  ListingController.swift
//  TesteAndre
//
//  Created by André Henrique da Silva on 14/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import UIKit

private let reuseIdentifier = "ProductCell"

class ListingController: UICollectionViewController {
    
    lazy var apiClient = WebserviceClient()
    
    var topContentViewHeightConstraint: NSLayoutConstraint?
    var topContentViewTopConstraint: NSLayoutConstraint?
    
    var propagateClicks: Bool = true
    
    var products: [ProductShort]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    let topContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkBackgroundColor()
        return view
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "relógios"
        label.font = Font.proximaNovaBold18
        label.textColor = UIColor.darkHighlightColor()
        return label
    }()
    
    lazy var sortButton: UIButton = {
        return self.simpleButton(title: "ordenar", action: #selector(ListingController.sort(_:)))
    }()
    
    lazy var filterButton: UIButton = {
        return self.simpleButton(title: "filtrar", action: #selector(ListingController.filter(_:)))
    }()
    
    func simpleButton(title: String, action: Selector?) -> UIButton {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = Font.proximaNovaBold14
        button.setTitleColor(UIColor.mainColor(), for: UIControlState())
        button.setTitle(title, for: UIControlState())
        
        if let actionForButton = action {
            button.addTarget(self, action: actionForButton, for: .touchUpInside)
        }
        
        return button
    }
    
    func sort(_ sender: UIButton?) {
        print("Should sort...")
    }
    
    func filter(_ sender: UIButton?) {
        print("Should filter...")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        setupViews()
        
        startService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        var c = navigationController?.navigationBar.subviews.count
        print(c)
        
        navigationController?.navigationBar.viewWithTag(116)?.isHidden = true
        
        navigationController?.navigationBar.viewWithTag(116)?.removeFromSuperview()
        
        c = navigationController?.navigationBar.subviews.count
        print(c)
    }
    
    func setupNavigationBar() {
        
        let width = view.frame.size.width
        
        let navView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: 74.0))
        navView.backgroundColor = UIColor.white
        navView.tag = 116
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 15.0, y: 28.0, width: 22.0, height: 14.0)
        backButton.setImage(UIImage(named: "BackButton"), for: UIControlState())
        navView.addSubview(backButton)
        
        let searchTextfield = UITextField(frame: CGRect(x: 52.0, y: 14.0, width: width - 75.0, height: 40.0))
        searchTextfield.borderStyle = .none
        searchTextfield.backgroundColor = UIColor.darkBackgroundColor()
        searchTextfield.layer.cornerRadius = 4.0
        searchTextfield.layer.masksToBounds = true
        searchTextfield.font = Font.proximaNovaLight16
        searchTextfield.placeholder = "o que você está procurando?"
        searchTextfield.delegate = self
        searchTextfield.returnKeyType = .search
        navView.addSubview(searchTextfield)
        
        let spacerView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 17.0))
        spacerView.image = UIImage(named: "Search")
        spacerView.contentMode = .scaleAspectFit
        
        searchTextfield.leftView = spacerView
        searchTextfield.leftViewMode = .always
        
        navView.clipsToBounds = true
        
        navigationController?.navigationBar.addSubview(navView)
    }
    
    func setupUI() {
        
        // Register cell classes
        collectionView!.register(ProductCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        collectionView?.backgroundColor = UIColor.darkBackgroundColor()
        collectionView?.alwaysBounceVertical = true
    }
    
    func setupViews() {
        
        topContentView.addSubview(categoryLabel)
        topContentView.addSubview(sortButton)
        topContentView.addSubview(filterButton)
        
        view.addConstraintWithFormat("H:|[v0]|", views: collectionView!)
        
        view.addSubview(topContentView)
        view.bringSubview(toFront: topContentView)
        
        view.addConstraintWithFormat("H:|[v0]|", views: topContentView)

        view.addConstraintWithFormat("V:[v0][v1]", views: topContentView, collectionView!)
        
        topContentViewHeightConstraint = NSLayoutConstraint(item: topContentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40.0)
        view.addConstraint(topContentViewHeightConstraint!)
        
        topContentViewTopConstraint = NSLayoutConstraint(item: topContentView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 30.0)
        view.addConstraint(topContentViewTopConstraint!)

        
        //// aqui
        let bottomConstraint = NSLayoutConstraint(item: collectionView!, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        view.addConstraint(bottomConstraint)


        topContentView.addConstraintWithFormat("H:|-20-[v0]-[v1(50)]-[v2(50)]-20-|", views: categoryLabel, sortButton, filterButton)
        topContentView.addConstraintWithFormat("V:|[v0(40)]|", views: categoryLabel)
        topContentView.addConstraintWithFormat("V:|[v0(40)]|", views: sortButton)
        topContentView.addConstraintWithFormat("V:|[v0(40)]|", views: filterButton)
            
        //fix collection view to accept top content view
        collectionView!.contentInset = UIEdgeInsetsMake(0.0, 0.0, 10.0, 0.0)
        self.automaticallyAdjustsScrollViewInsets = false

    }
    
    func startService() {
        apiClient.fetchProductsList { (result) in
            
            switch result {
            case .success(var products):
                
                for i in 0..<products.count {
                    
                    var p = products[i]
                    
                    let index = i + 1
                    
                    p.productURL = "caironoleto/9cd18d9642a7d5e8eef0/raw/dbe726570f063e2be2b353fd35d48ff9f9180b52/product_0\(index).json"
                    
                    products[i] = p
                }
                
                self.products = products
            break
            case .failure(let error as NSError):
                print(error.localizedDescription)
            break
            default: break
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProductCell
    
        cell.product = products![(indexPath as NSIndexPath).row]
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if propagateClicks {
            
            //only goes one level inside hierarchy because no product url comes from server
            
            let p = products![(indexPath as NSIndexPath).row]
            
            var product = Product()
            product.productURL = p.productURL
            product.title = p.title
            
            let productController = ProductController()
            productController.product = product
            
            productController.hidesBottomBarWhenPushed = true
            
            navigationController?.pushViewController(productController, animated: true)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        navigationController?.navigationBar.viewWithTag(116)?.removeFromSuperview()
        
        collectionView?.collectionViewLayout.invalidateLayout()
        
        setupNavigationBar()
    }
}

extension ListingController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.size.width - 30.0) / 2.0, height: 317.0)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(10.0, 10.0, 0.0, 10.0)
        
    }
}

extension ListingController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        navigationController?.navigationBar.endEditing(true)
        return true
    }
}
