//
//  ViewController.swift
//  Teko
//
//  Created by admin on 17.08.2021.
//

import UIKit
//import NotificationCenter
import RealmSwift

final class GifViewController: UIViewController, Storyboarded {
//MARK: - IBOutlet
    @IBOutlet var collectionView: UICollectionView!
    
//MARK: - Properties
    private var gifs = [Gifs]()
    var coordinator: MainCoordinators?
    private var dataUrls = [Gifs]()
    private var isIndicater = true
    private var selectedImages = [UIImage]()
    private let networkData = NetworkData()
    private let itemsPerRow: CGFloat = 2
    private let sectionInsert = UIEdgeInsets(top: 20 , left: 10, bottom: 20, right: 10)
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTap))
    }()
    
    private lazy var refreshBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(upadteNavigButton))
    }()
    
    private let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    private var numberOfSelectesGifs: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "GIF"
        setupCollectionView()
        setupNavigationBar()
        getNetwork()
        
    }
//MARK: Configure
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [refreshBarButtonItem, addBarButtonItem]
    }
    
    private func setupTabBarItem() {
        var tabBar = UITabBarItem()
        tabBar = UITabBarItem(title: "GIF", image: UIImage(systemName: "photo.on.rectangle"), tag: 1)
        tabBarItem = tabBar
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GifCell.self, forCellWithReuseIdentifier: GifCell.reuseId)
        collectionView.refreshControl = myRefreshControl
        collectionView.contentInsetAdjustmentBehavior = .automatic
        //разрешает делать множественный выбор ячеик
        collectionView.allowsMultipleSelection = true
        
    }
    
//MARK: - NavigationItems action
    @objc private func addBarButtonTap() {
        let selectedGifs = collectionView.indexPathsForSelectedItems?.reduce([], { (photos, indexPath) -> [Gifs] in
            var mutablePhotos = photos
            let photo = gifs[indexPath.item]
            mutablePhotos.append(photo)
            return mutablePhotos
        })
        
        let alertController = UIAlertController(title: "", message: "\(selectedGifs!.count) Gif будут добавлены в Favourites", preferredStyle: .alert)
        let add = UIAlertAction(title: "Добавить", style: .default) { [weak self] (action) in
            guard let self = self else { return }
            self.dataUrls.append(contentsOf: selectedGifs ?? [])
            Gifs.add(gifs: self.dataUrls)
            self.refreshImage()
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel) { (action) in
        }
        alertController.addAction(add)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    @objc private func upadteNavigButton() {
        getNetwork()
    }
    
    @objc private func refresh(sender: UIRefreshControl){
        getNetwork()
        sender.endRefreshing()
    }
    @objc func refreshImage() {
        selectedImages.removeAll()
        collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
    }
    
//MARK: - Network
    private func getNetwork() {
        networkData.fethImages { [weak self] (gifResult) in
            guard let fetchGifs = gifResult else { return }
            self?.gifs = fetchGifs.data
            self?.isIndicater = true
            self?.collectionView.reloadData()
        }
    }
}
//MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension GifViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifCell.reuseId , for: indexPath) as! GifCell
        let gif = gifs[indexPath.row]
        cell.isIndacator(isAnimated: isIndicater)
        cell.set(gif: gif)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension GifViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GifCell
        guard let image = cell.gifImageView.image else { return }
        selectedImages.append(image)
        print(indexPath)
        print(image)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GifCell
        guard let image = cell.gifImageView.image else { return }
        if let index = selectedImages.firstIndex(of: image){
            selectedImages.remove(at: index)
            print("delet \(index)")
        }
    }
}

//MARK: - Работа с LAyout ячеками
extension GifViewController: UICollectionViewDelegateFlowLayout {
    
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


