//
//  ProductController.swift
//  TesteAndre
//
//  Created by André Henrique da Silva on 15/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class ProductController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    lazy var apiClient = WebserviceClient()
    
    var relatedController: ListingController?
    
    let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.numberOfPages = 10
        control.hidesForSinglePage = true
        return control
    }()
    
    var indexForPhoto: Int = 0
    
    var product: Product? {
        didSet {
            
            if let price = product?.price, let original = product?.originalPrice {
                
                let oldPrice = "\(original.toCurrency())"
                
                let attributedText = NSMutableAttributedString(string: oldPrice, attributes: [NSFontAttributeName: Font.proximaNovaLight22, NSForegroundColorAttributeName: UIColor.middleHighlightColor()])
                
                attributedText.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, oldPrice.characters.count))

                let newPrice = price.toCurrency().components(separatedBy: " ")
                
                attributedText.append(NSAttributedString(string: " \(newPrice[0]) ", attributes: [NSFontAttributeName: Font.proximaNovaLight22, NSForegroundColorAttributeName: UIColor.darkColor()]))
                
                attributedText.append(NSAttributedString(string: newPrice[1], attributes: [NSFontAttributeName: Font.proximaNovaBold22, NSForegroundColorAttributeName: UIColor.darkColor()]))
                
                priceLabel.attributedText = attributedText
                
            }
            
            if let discount = product?.discountPercentage {
                
                if discount > 0 {
                    offLabel.text = "\(discount)% OFF"
                } else {
                    offLabel.text = ""
                }
            }
            
            if var descr = product?.content {
                descriptionLabel.text = descr
                
                let size = NSString(string: descr).boundingRect(with: CGSize(width: self.view.frame.size.width - 60.0, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: Font.proximaNovaLight16], context: nil)
                
                //88.0 is the height of the label
                if size.height > 88.0 {
                    
                    descr = (descr as NSString).substring(to: 120)
                    
                    descr = "\(descr)... "
                    
                    let attributedText = NSMutableAttributedString(string: descr, attributes: [NSFontAttributeName: Font.proximaNovaLight16, NSForegroundColorAttributeName: descriptionLabel.textColor!])
                    
                    attributedText.append(NSAttributedString(string: "leia mais", attributes: [NSFontAttributeName: Font.proximaNovaLight16, NSForegroundColorAttributeName: UIColor.middleHighlightColor()]))
                    
                    descriptionLabel.attributedText = attributedText
                }
            }
            
            likesLabel.text = product?.likesCount.toString()
            sizeLabel.text = product?.size
            brandLabel.text = product?.brand
            conditionLabel.text = product?.condition
            shippingLabel.text = product?.shippingType
            
            userTitleLabel.text = product?.userTitle
            userLocationLabel.text = "\(product!.userCity), \(product!.userState)"
            
            relatedController?.products = product?.relatedProducts
            
            if product?.photos?.count > 0 {
                setupPageController()
            }
            
            self.title = product?.title
        }
    }
    
    var pageController: UIPageViewController?
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    let actionView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()

    let storeContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkBackgroundColor()
        return view
    }()
    
    let photoContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightColor()
        return view
    }()
    
    let topActionContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let topActionSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkBackgroundColor()
        return view
    }()
    
    let detailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.darkBackgroundColor()
        return view
    }()
    
    let bottomActionContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Font.proximaNovaLight22
        label.textColor = UIColor.middleHighlightColor()
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let offLabel: UILabel = {
        let label = UILabel()
        label.font = Font.proximaNovaLight14
        label.textColor = UIColor.mainColor()
        return label
    }()
    
    lazy var commentButton: UIButton = {
        if let image = UIImage(named: "CommentAction") {
            return UIButton.actionButton(image)
        }
        return UIButton(type: .custom)
    }()
    
    lazy var likeButton: UIButton = {
        if let image = UIImage(named: "LikeAction") {
            return UIButton.actionButton(image)
        }
        return UIButton(type: .custom)
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Font.proximaNovaLight16
        label.textColor = UIColor.darkColor()
        label.numberOfLines = 4
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let detailContentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var detailLikesLabel: UILabel = {
        return self.detailLabel("yeahyeahs")
    }()
    
    lazy var likesLabel: UILabel = {
        return self.valueLabel()
    }()
    
    lazy var detailSizeLabel: UILabel = {
        return self.detailLabel("tamanho")
    }()
    
    lazy var sizeLabel: UILabel = {
        return self.valueLabel()
    }()
    
    lazy var detailBrandLabel: UILabel = {
        return self.detailLabel("Marca")
    }()
    
    lazy var brandLabel: UILabel = {
        return self.valueLabel()
    }()
    
    lazy var detailConditionLabel: UILabel = {
        return self.detailLabel("condição")
    }()
    
    lazy var conditionLabel: UILabel = {
        return self.valueLabel()
    }()
    
    lazy var detailShippingLabel: UILabel = {
        return self.detailLabel("frete")
    }()
    
    lazy var shippingLabel: UILabel = {
        return self.valueLabel()
    }()
    
    func detailLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = Font.proximaNovaLight16
        label.textColor = UIColor.mainColor()
        return label
    }

    func valueLabel() -> UILabel {
        let label = UILabel()
        label.font = Font.proximaNovaRegular16
        label.textColor = UIColor.darkColor()
        return label
    }

    let bigBagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "BigBag")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let newBagLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "nova ", attributes: [NSFontAttributeName: Font.proximaNovaBold20, NSForegroundColorAttributeName: UIColor.darkColor()])
        
        attributedText.append(NSAttributedString(string: "sacolinha ", attributes: [NSFontAttributeName: Font.proximaNovaBold20, NSForegroundColorAttributeName: UIColor.middleHighlightColor()]))

        attributedText.append(NSAttributedString(string: "enjoei", attributes: [NSFontAttributeName: Font.proximaNovaBold20, NSForegroundColorAttributeName: UIColor.darkColor()]))
        
        label.attributedText = attributedText

        label.textAlignment = .center
        
        return label
    }()
    
    let newBagTextLabel: UILabel = {
        let label = UILabel()
        label.font = Font.proximaNovaLight16
        label.textColor = UIColor.mainColor()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.text = "adicione até 5 produtos dessa lojinha, faça sua oferta e pague um frete só"
        label.minimumScaleFactor = 0.7
        label.adjustsFontSizeToFitWidth = true

        return label
    }()
    
    let addToBagButton: UIButton = {
        let image = UIImage(named: "SmallBag")!
        return UIButton.fancyButton(title: "adicionar à sacolinha", image: image)
    }()
    
    let userHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 24.0
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.lightColor()
        return imageView
    }()
    
    lazy var followButton: UIButton = {
        if let image = UIImage(named: "Follow") {
            return UIButton.actionButton(image)
        }
        return UIButton(type: .custom)
    }()
    
    let userTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.proximaNovaBold20
        label.textColor = UIColor.darkColor()
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true

        return label
    }()
    
    let userLocationLabel: UILabel = {
        let label = UILabel()
        label.font = Font.proximaNovaLight16
        label.textColor = UIColor.mainColor()
        label.minimumScaleFactor = 0.8
        label.adjustsFontSizeToFitWidth = true

        return label
    }()
    
    let textSeparatorLabel: UILabel = {
        let label = UILabel()
        label.font = Font.proximaNovaRegular16
        label.textColor = UIColor.darkColor()
        label.backgroundColor = UIColor.darkBackgroundColor()
        label.text = "você também vai curtir"
        label.textAlignment = .center
        return label
    }()
    
    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.shadowColor()
        return view
    }()
    
    let relatedProductsView: UIView = {
        let view = UIView()
        return view
    }()

    let offerButton: UIButton = {
        let image = UIImage(named: "Offer")!
        return UIButton.fancyButton(title: "fazer oferta", image: image)
    }()
    
    let cartButton: UIButton = {
        let image = UIImage(named: "Cart")!
        return UIButton.fancyButton(title: "eu quero", image: image, backgroundColor: UIColor.middleHighlightColor(), titleColor: UIColor.white, fakeShadowColor: UIColor.highlightShadowColor())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        setupViews()
        
//        setupPageController()
        
        setupRelatedProducts()
        
        startService()
    }
    
    func setupUI() {
        
        self.title = "nome do produto"
        
        let backImage = UIImage(named: "BackButton")
        
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(ProductController.goBack(_:)))
        
        navigationItem.leftBarButtonItem = backButton
        
        view.backgroundColor = UIColor.darkBackgroundColor()
    }
    
    func setupViews() {
        
        /*** SCROLL VIEW ***/
        
        view.addSubview(scrollView)
        view.addSubview(actionView)
        
        scrollView.addSubview(contentView)
        scrollView.addSubview(storeContentView)
        
        view.addConstraintWithFormat("H:|[v0]|", views: scrollView)
        view.addConstraintWithFormat("H:|[v0]|", views: actionView)
        view.addConstraintWithFormat("V:[v0][v1(68)]|", views: scrollView, actionView)
        
        let topContentViewTopConstraint = NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        view.addConstraint(topContentViewTopConstraint)
        
        scrollView.addConstraintWithFormat("H:[v0(==v1)]", views: contentView, scrollView)
        
        scrollView.addConstraintWithFormat("H:[v0(==v1)]", views: storeContentView, scrollView)
        
        let viewWidth = view.frame.width
        var contentViewHeight = 0
        
        switch viewWidth {
            case 320:
                contentViewHeight = 935
            case 375:
                contentViewHeight = 995
            case 414:
                contentViewHeight = 1035
            default:
                contentViewHeight = 1000
            break
        }
        
        scrollView.addConstraintWithFormat("V:[v0(==\(contentViewHeight))][v1(==830)]", views: contentView, storeContentView)
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: CGFloat(contentViewHeight) + 830.0)
        
        /*** BOTTOM ACTION VIEW ***/
        
        actionView.addSubview(offerButton)
        actionView.addSubview(cartButton)
        
        actionView.addConstraintWithFormat("H:|-[v0]-[v1(==v0)]-|", views: offerButton, cartButton)
        
        actionView.addConstraintWithFormat("V:|-14-[v0(41)]", views: offerButton)
        actionView.addConstraintWithFormat("V:|-14-[v0(41)]", views: cartButton)
        
        /*** BOTTOM ACTION VIEW ***/
        
        /*** SCROLL VIEW ***/
        
        /*** CONTENT VIEW ***/
        
        contentView.addSubview(photoContentView)
        contentView.addSubview(topActionContentView)

        contentView.addConstraintWithFormat("H:|[v0]|", views: photoContentView)
        contentView.addConstraintWithFormat("H:|[v0]|", views: topActionContentView)

        let photoContentViewHeightConstraint = NSLayoutConstraint(item: photoContentView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1.056, constant: 0.0)
        
        contentView.addConstraint(photoContentViewHeightConstraint)

        contentView.addConstraintWithFormat("V:[v0][v1(95)]", views: photoContentView, topActionContentView)
        
        /*** CONTENT VIEW ***/
        
        /*** TOP ACTION VIEW ***/
        
        topActionContentView.addSubview(priceLabel)
        topActionContentView.addSubview(offLabel)
        topActionContentView.addSubview(commentButton)
        topActionContentView.addSubview(likeButton)
        
        topActionContentView.addConstraintWithFormat("H:|-32-[v0]-[v1(55)]-[v2(55)]-20-|", views: priceLabel, commentButton, likeButton)
        topActionContentView.addConstraintWithFormat("H:|-32-[v0(==v1)]", views: offLabel, priceLabel)
        topActionContentView.addConstraintWithFormat("V:|-20-[v0(27)]-[v1(17)]", views: priceLabel, offLabel)
        topActionContentView.addConstraintWithFormat("V:|-20-[v0(55)]", views: commentButton)
        topActionContentView.addConstraintWithFormat("V:|-20-[v0(55)]", views: likeButton)
        
        // TODO: Add notification count for comments
        
        /*** TOP ACTION VIEW ***/
        
        /*** SEPARATOR VIEW ***/
        
        contentView.addSubview(topActionSeparatorView)
        
        contentView.addConstraintWithFormat("H:|[v0]|", views: topActionSeparatorView)
        contentView.addConstraintWithFormat("V:[v0][v1(0.5)]", views: topActionContentView, topActionSeparatorView)
        
        /*** SEPARATOR VIEW ***/
        
        /*** PRODUCT DESCRIPTION ***/
        
        contentView.addSubview(descriptionLabel)
        
        contentView.addConstraintWithFormat("H:|-20-[v0]-40-|", views: descriptionLabel)
        contentView.addConstraintWithFormat("V:[v0]-8-[v1(88)]", views: topActionSeparatorView, descriptionLabel)
        
        /*** PRODUCT DESCRIPTION ***/
        
        /*** DETAIL INFO VIEW ***/
        
        contentView.addSubview(detailContentView)
        
        contentView.addConstraintWithFormat("H:|[v0]|", views: detailContentView)
        contentView.addConstraintWithFormat("V:[v0]-[v1(190)]", views: descriptionLabel, detailContentView)
        
        detailContentView.addSubview(detailLikesLabel)
        detailContentView.addSubview(likesLabel)
        
        detailContentView.addSubview(detailSizeLabel)
        detailContentView.addSubview(sizeLabel)
        
        detailContentView.addSubview(detailBrandLabel)
        detailContentView.addSubview(brandLabel)
        
        detailContentView.addSubview(detailConditionLabel)
        detailContentView.addSubview(conditionLabel)
        
        detailContentView.addSubview(detailShippingLabel)
        detailContentView.addSubview(shippingLabel)
        
        detailContentView.addConstraintWithFormat("H:|-20-[v0(75)]-20-[v1]|", views: detailLikesLabel, likesLabel)
        detailContentView.addConstraintWithFormat("H:|-20-[v0(75)]-20-[v1]|", views: detailSizeLabel, sizeLabel)
        detailContentView.addConstraintWithFormat("H:|-20-[v0(75)]-20-[v1]|", views: detailBrandLabel, brandLabel)
        detailContentView.addConstraintWithFormat("H:|-20-[v0(75)]-20-[v1]|", views: detailConditionLabel, conditionLabel)
        detailContentView.addConstraintWithFormat("H:|-20-[v0(75)]-20-[v1]|", views: detailShippingLabel, shippingLabel)
        
        detailContentView.addConstraintWithFormat("V:|-[v0(26)]-[v1(26)]-[v2(26)]-[v3(26)]-[v4(26)]", views: detailLikesLabel, detailSizeLabel, detailBrandLabel, detailConditionLabel, detailShippingLabel)
        detailContentView.addConstraintWithFormat("V:|-[v0(26)]-[v1(26)]-[v2(26)]-[v3(26)]-[v4(26)]", views: likesLabel, sizeLabel, brandLabel, conditionLabel, shippingLabel)
        
        /*** DETAIL INFO VIEW ***/
        
        /*** DETAIL SEPARATOR VIEW ***/
        
        //detailSeparatorView
        
        contentView.addSubview(detailSeparatorView)
        
        contentView.addConstraintWithFormat("H:|[v0]|", views: detailSeparatorView)
        contentView.addConstraintWithFormat("V:[v0][v1(0.5)]", views: detailContentView, detailSeparatorView)

        /*** DETAIL SEPARATOR VIEW ***/
        
        /*** NEW BAG VIEW ***/
        
        contentView.addSubview(bigBagImageView)
        
        contentView.addConstraintWithFormat("H:[v0(50)]", views: bigBagImageView)
        contentView.addConstraintWithFormat("V:[v0]-10-[v1(48)]", views: detailSeparatorView, bigBagImageView)
        
        let bigBagImageViewCenterXConstraint = NSLayoutConstraint(item: bigBagImageView, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        
        contentView.addConstraint(bigBagImageViewCenterXConstraint)
        
        contentView.addSubview(newBagLabel)
        contentView.addSubview(newBagTextLabel)
        contentView.addSubview(addToBagButton)
        
        contentView.addConstraintWithFormat("H:|-20-[v0]-20-|", views: newBagLabel)
        contentView.addConstraintWithFormat("H:|-30-[v0]-30-|", views: newBagTextLabel)
        contentView.addConstraintWithFormat("H:|-24-[v0]-24-|", views: addToBagButton)
        
        contentView.addConstraintWithFormat("V:[v0]-10-[v1(24)]-12-[v2]-12-[v3(40)]", views: bigBagImageView, newBagLabel, newBagTextLabel, addToBagButton)
        
        /*** NEW BAG VIEW ***/
        
        /*** USER VIEW ***/
        
        storeContentView.addSubview(userHeaderView)
        
        storeContentView.addConstraintWithFormat("H:|[v0]|", views: userHeaderView)
        storeContentView.addConstraintWithFormat("V:|-30-[v0(88)]", views: userHeaderView)
        
        userHeaderView.addSubview(userImageView)
        userHeaderView.addSubview(userTitleLabel)
        userHeaderView.addSubview(userLocationLabel)
        userHeaderView.addSubview(followButton)
        
        userHeaderView.addConstraintWithFormat("H:|-30-[v0(48)]-20-[v1]-20-[v2(55)]-30-|", views: userImageView, userTitleLabel, followButton)
        userHeaderView.addConstraintWithFormat("H:|-30-[v0(48)]-20-[v1]-20-[v2(55)]-30-|", views: userImageView, userLocationLabel, followButton)
        
        userHeaderView.addConstraintWithFormat("V:|-20-[v0(48)]", views: userImageView)
        userHeaderView.addConstraintWithFormat("V:|-20-[v0(25)]-0-[v1(21)]", views: userTitleLabel, userLocationLabel)
        userHeaderView.addConstraintWithFormat("V:|-16-[v0(55)]", views: followButton)
        
        /*** USER VIEW ***/
        
        /*** TEXT SEPARATOR VIEW ***/
        
        storeContentView.addSubview(lineSeparatorView)
        storeContentView.addSubview(textSeparatorLabel)
        
        storeContentView.addConstraintWithFormat("H:|-[v0]-|", views: lineSeparatorView)
        storeContentView.addConstraintWithFormat("V:[v0]-30-[v1(0.5)]", views: userHeaderView, lineSeparatorView)
        
        storeContentView.addConstraintWithFormat("H:[v0(180)]", views: textSeparatorLabel)
        
        let textSeparatorLabelCenterXConstranint = NSLayoutConstraint(item: textSeparatorLabel, attribute: .centerX, relatedBy: .equal, toItem: lineSeparatorView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        storeContentView.addConstraint(textSeparatorLabelCenterXConstranint)
        
        storeContentView.addConstraintWithFormat("V:[v0]-20-[v1(15)]", views: userHeaderView, textSeparatorLabel)
        
        /*** TEXT SEPARATOR VIEW ***/
        
        /*** RELATED PRODUCTS ***/
        
        storeContentView.addSubview(relatedProductsView)
        
        storeContentView.addConstraintWithFormat("H:|[v0]|", views: relatedProductsView)
        storeContentView.addConstraintWithFormat("V:[v0]-10-[v1(660)]", views: textSeparatorLabel, relatedProductsView)
        
        
        /*** RELATED PRODUCTS ***/
    }
    
    func setupPageController() {
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController?.delegate = self
        pageController?.dataSource = self
        
        addChildViewController(pageController!)
        
        pageController?.view.frame = CGRect(x: 0.0, y: 0.0, width: photoContentView.bounds.width, height: photoContentView.bounds.height)
        photoContentView.addSubview(pageController!.view)
        pageController!.didMove(toParentViewController: self)
        
        pageControl.numberOfPages = (product?.photos?.count)!
        pageControl.currentPage = 0
        photoContentView.addSubview(pageControl)
        photoContentView.addConstraintWithFormat("H:|-[v0]-|", views: pageControl)
        photoContentView.addConstraintWithFormat("V:[v0]-6-|", views: pageControl)
        
        if let _ = product?.photos {
            
            let controller = viewControllerAtIndex(0)
            
            pageController?.setViewControllers([controller! as PhotoViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setupRelatedProducts() {
        
        relatedController = ListingController(collectionViewLayout: UICollectionViewFlowLayout())
        relatedController?.propagateClicks = false
        
        addChildViewController(relatedController!)
        
        relatedController?.view.frame = CGRect(x: 0.0, y: 0.0, width: relatedProductsView.bounds.width, height: relatedProductsView.bounds.height)
        relatedProductsView.addSubview(relatedController!.view)
        relatedController!.didMove(toParentViewController: self)
        
        //hides sort/filter buttons
        relatedController?.topContentView.isHidden = true
        
        // TODO: Remove constraint issue!!!
        
        relatedController?.topContentView.removeConstraints((relatedController?.topContentView.constraints)!)
        relatedController?.view.removeConstraint((relatedController?.topContentViewTopConstraint)!)
        
        relatedController?.topContentViewHeightConstraint?.constant = 1.0
        
        relatedController?.view.addConstraint((relatedController?.topContentViewHeightConstraint)!)
        relatedController?.view.addConstraintWithFormat("V:|[v0(1)]", views: (relatedController?.topContentView)!)
        
        relatedController?.collectionView?.isScrollEnabled = false
    }
    
    func startService() {
        
        apiClient.fetchProduct((product?.productURL)!) { (result) in
            
            switch result {
                
            case .success(let prod):
                    self.product = prod
                break
            case .failure(let error as NSError):
                    print(error.localizedDescription)
                break
            default: break
            }
            
        }
        
    }
    
    func goBack(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func viewControllerAtIndex(_ index: Int) -> PhotoViewController? {
        
        if product?.photos?.count == 0 || index >= product?.photos?.count {
            return nil
        }
        
        let photoViewController = PhotoViewController()
        photoViewController.urlString = product?.photos?[index]
        
        return photoViewController
    }
    
    func indexOfViewController(_ viewController: PhotoViewController) -> Int {
        if let url = viewController.urlString {
            let index = (product?.photos?.index(of: url))!
            indexForPhoto = index
            return index
        } else {
            return NSNotFound
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = indexOfViewController(viewController as! PhotoViewController)
        
        pageControl.currentPage = index
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = indexOfViewController(viewController as! PhotoViewController)
        
        pageControl.currentPage = index
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == product?.photos?.count {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
}

