//
//  MainTabBarViewController.swift
//  Teko
//
//  Created by admin on 18.08.2021.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        let gifVC = GifCollectionViewController(collectionViewLayout: UICollectionViewLayout())
        let navigationVC = UINavigationController(rootViewController: gifVC)
        navigationVC.tabBarItem.title = "Gif"
        navigationVC.tabBarItem.image = UIImage(systemName: "photo.on.rectangle.angled")
        
        viewControllers = [generateNavigationController(rootViewController: gifVC, title: "GIF", image: "photo.on.rectangle.angled"),
                           generateNavigationController(rootViewController: ViewController(), title: "Favourites", image: "arrow.down.heart.fill")]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = UIImage(systemName: image)
        return navigationVC
    }
}
