//
//  MainCoordinators.swift
//  Teko
//
//  Created by admin on 26.08.2021.
//

import Foundation
import UIKit

final class MainCoordinators: Coordinator {
//MARK: - Properties
    var childCoordinators = [Coordinator]()
    var tabBarVC: UITabBarController
    var navigationController: UINavigationController
//MARK: - Init
    init(navigationController: UINavigationController, tabBarController: UITabBarController) {
        self.navigationController = navigationController
        self.tabBarVC = tabBarController
    }
//MARK: - Functions
    func start() {
        let vc = LikeViewController.instantiate()
        vc.coordinator = self
        let gifsVC = GifViewController.instantiate()
        gifsVC.coordinator = self
        let gifsNavigVC = UINavigationController(rootViewController: gifsVC)
        gifsVC.title = "GIFS"
        gifsVC.tabBarItem.image = UIImage(systemName: "photo.on.rectangle")
        tabBarVC.setViewControllers([navigationController,gifsNavigVC], animated: true)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goGifVC() {
        let vc = GifViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
}

