//
//  TabController.swift
//  TesteAndre
//
//  Created by André Henrique da Silva on 14/07/2016.
//  Copyright © 2016 André Henrique da Silva. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barStyle = .black
        self.tabBar.isTranslucent = false
        
        let homeController = HomeController()
        let homeIcon = UITabBarItem(title: nil, image: UIImage(named: "Home"), selectedImage: UIImage(named: "Home"))
        homeController.tabBarItem = homeIcon
        
        let listingController = ListingController(collectionViewLayout: UICollectionViewFlowLayout())
        let listingIcon = UITabBarItem(title: nil, image: UIImage(named: "List"), selectedImage: UIImage(named: "List"))
        listingController.tabBarItem = listingIcon
        
        let listingNavController = UINavigationController(rootViewController: listingController)
        
        let photoController = PhotoController()
        let photoIcon = UITabBarItem(title: nil, image: UIImage(named: "Photo"), selectedImage: UIImage(named: "Photo"))
        photoController.tabBarItem = photoIcon
        
        let inboxController = InboxController()
        let inboxIcon = UITabBarItem(title: nil, image: UIImage(named: "Inbox"), selectedImage: UIImage(named: "Inbox"))
        inboxController.tabBarItem = inboxIcon
        
        let miscController = MiscController()
        let miscIcon = UITabBarItem(title: nil, image: UIImage(named: "Misc"), selectedImage: UIImage(named: "Misc"))
        miscController.tabBarItem = miscIcon
        
        let controllers = [homeController, listingNavController, photoController, inboxController, miscController]
        
        self.viewControllers = controllers
        
        //change images to darker color
        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(UIColor.darkColor()).withRenderingMode(.alwaysOriginal)
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.selectedIndex = 1
    }
}
