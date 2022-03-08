//
//  TabBarViewController.swift
//  Spotify
//
//  Created by THANSEEF on 08/03/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //creating variable to access different controllers
        let vc1 = HomeViewController()
        let vc2 = SearchViewController()
        let vc3 = LibraryViewController()
        
        //assinging titles to it.
        vc1.title = "Home"
        vc2.title = "Search"
        vc3.title = "Library"
        
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        
        //creating those view controller as a navigations controllers.
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 1)
        
        //the navigation bar allows the title to be displayed out-of-line and using a larger font
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1,nav2,nav3], animated: false)
        
        
    }
    

}
