//
//  Storyboarded.swift
//  Teko
//
//  Created by admin on 26.08.2021.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboarde = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboarde.instantiateViewController(withIdentifier: id) as! Self
    }
}
