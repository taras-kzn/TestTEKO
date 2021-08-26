//
//  Coordinator.swift
//  Teko
//
//  Created by admin on 26.08.2021.
//

import Foundation
import UIKit

protocol Coordinator {
    //MARK: - Properties
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    //MARK: - Function
    func start()
}
