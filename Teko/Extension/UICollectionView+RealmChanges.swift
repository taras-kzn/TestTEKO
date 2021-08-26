//
//  UICollectionView+RealmChanges.swift
//  Teko
//
//  Created by admin on 26.08.2021.
//

import UIKit

extension IndexPath {
  static func fromItem(_ item: Int) -> IndexPath {
    return IndexPath(item: item, section: 0)
  }
}

extension UICollectionView {
  func applyChanges(deletions: [Int], insertions: [Int], updates: [Int]) {
    deleteItems(at: deletions.map(IndexPath.fromItem))
    insertItems(at: insertions.map(IndexPath.fromItem))
    reloadItems(at: updates.map(IndexPath.fromItem))
  }
}
