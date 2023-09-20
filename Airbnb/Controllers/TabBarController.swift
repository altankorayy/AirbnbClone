//
//  ViewController.swift
//  Airbnb
//
//  Created by Altan on 18.09.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let exploreVC = UINavigationController(rootViewController: ExploreViewController())
        let mapVC = UINavigationController(rootViewController: MapViewController())
        let profileVC = UINavigationController(rootViewController: ProfileViewController())
        
        exploreVC.tabBarItem.image = UIImage(named: "explore")
        exploreVC.tabBarItem.selectedImage = UIImage(named: "explore2")
        mapVC.tabBarItem.image = UIImage(named: "airbnb")
        mapVC.tabBarItem.selectedImage = UIImage(named: "airbnb2")
        profileVC.tabBarItem.image = UIImage(named: "profile")
        profileVC.tabBarItem.selectedImage = UIImage(named: "profile2")
        
        exploreVC.title = "Explore"
        mapVC.title = "Map"
        profileVC.title = "Profile"
        
        tabBar.tintColor = UIColor(red: 232/255, green: 28/255, blue: 84/255, alpha: 1)
        
        setViewControllers([exploreVC, mapVC, profileVC], animated: true)
    }


}

