//
//  LikeViewController.swift
//  Teko
//
//  Created by admin on 23.08.2021.
//

import UIKit
import RealmSwift

final class LikeViewController: UIViewController, Storyboarded {
//MARK: - IBOutlet
    @IBOutlet var collectionView: UICollectionView!
//MARK: - Properties
    private var selected = [IndexPath]()
    var coordinator: MainCoordinators?
    private var gifs: Results<Gifs>?
    private let networkData = NetworkData()
    private var itemsToken: NotificationToken?
    private let itemsPerRow: CGFloat = 2
    private let sectionInsert = UIEdgeInsets(top: 20 , left: 10, bottom: 20, right: 10)
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColletionView()
        setupTabBArItem()
        gifs = Gifs.all()
        
        if gifs?.count == 0 {
            messangeUser()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        itemsToken = gifs?.observe { [weak self] changes in
            guard let self = self else { return }
            guard let collectionView = self.collectionView else { return }

          switch changes {
          case .initial:
            collectionView.reloadData()
          case .update(_, let deletions, let insertions, let updates):
            collectionView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
          case .error: break
          }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      itemsToken?.invalidate()
    }
//MARK: - Setup
    private func setupColletionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "LikeViewCell", bundle: nil), forCellWithReuseIdentifier: LikeViewCell.reuseId)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
    
    private func setupTabBArItem() {
        var tabBar = UITabBarItem()
        tabBar = UITabBarItem(title: "egrfd", image: UIImage(systemName: "arrow.down.heart"), tag: 0)
        self.tabBarItem = tabBar
    }
//MARK: - private functions
    private func messangeUser() {
        let alertController = UIAlertController(title: "", message: "У Вас еще нет Gif в Favourites", preferredStyle: .alert)
        let action = UIAlertAction(title: "Перейти на другой экран", style: .default) { [weak self] action in
            guard let self = self else { return }
            self.coordinator?.goGifVC()
           
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel) { (action) in
        }
        
        alertController.addAction(action)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    private func deleteItem(_ item: Gifs) {
        item.delete()
    }
    
}
//MARK: - UICollectionViewDataSource
extension LikeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikeViewCell.reuseId, for: indexPath) as! LikeViewCell
        guard let gifsArray = gifs else { return LikeViewCell(frame: .zero)}
        let gif = gifsArray[indexPath.item]
        cell.set(gif: gif)
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate
extension LikeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let gif = gifs?[indexPath.item] else { return }
        deleteItem(gif)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension LikeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsert.left * (itemsPerRow + 1)
        let availabelWidth = view.frame.width - paddingSpace
        let widthPerItem = availabelWidth / 2
        let heght = CGFloat(200) * widthPerItem / CGFloat(200)
        return CGSize(width: widthPerItem, height: heght)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsert
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsert.left
    }
}
