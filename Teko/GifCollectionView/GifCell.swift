//
//  GifCell.swift
//  Teko
//
//  Created by admin on 19.08.2021.
//

import UIKit

final class GifCell: UICollectionViewCell {
 //MARK: - Properties
    static let reuseId = "GifCell"
    private var dataProvider = DataProviderImage()
    
    private let oneView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let activityIndicat: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    let gifImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let checkMark: UIImageView = {
        let image = UIImage(systemName: "checkmark.rectangle")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        return imageView
    }()
    
    private var image: UIImage? {
        didSet {
            gifImageView.image = image
            isIndacator(isAnimated: false)
        }
    }
//MARK: - Life Cycle
    override var isSelected: Bool {
        didSet{
            updateState()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gifImageView.image = nil
    }
//MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateState()
        setupImageView()
        setupCheckmarkView()
        stupTestView()
        setupActivityView()
        
    }
//MARK: - Setup View
    private func stupTestView() {
        addSubview(oneView)
        oneView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        oneView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        oneView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        oneView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func setupImageView() {
        oneView.addSubview(gifImageView)
        gifImageView.topAnchor.constraint(equalTo: oneView.topAnchor, constant: 5).isActive = true
        gifImageView.trailingAnchor.constraint(equalTo: oneView.trailingAnchor,constant: -5).isActive = true
        gifImageView.leadingAnchor.constraint(equalTo: oneView.leadingAnchor, constant: 5).isActive = true
        gifImageView.bottomAnchor.constraint(equalTo: oneView.bottomAnchor,constant: -5).isActive = true
        
    }
    
    private func setupActivityView() {
        oneView.addSubview(activityIndicat)
        activityIndicat.centerYAnchor.constraint(equalTo: gifImageView.centerYAnchor).isActive = true
        activityIndicat.centerXAnchor.constraint(equalTo: gifImageView.centerXAnchor).isActive = true
        isIndacator(isAnimated: true)
    }
    
    private func setupCheckmarkView() {
        gifImageView.addSubview(checkMark)
        checkMark.trailingAnchor.constraint(equalTo: gifImageView.trailingAnchor, constant: -8).isActive = true
        checkMark.bottomAnchor.constraint(equalTo: gifImageView.bottomAnchor, constant: -8).isActive = true
    }
//MARK: - Functions
    private func updateState() {
        gifImageView.alpha = isSelected ? 0.7 : 1
        checkMark.alpha = isSelected ? 1 : 0
    }
    
    func set(gif: Gifs) {
        let gifUrl = gif.urlGifs
        guard let url = URL(string: gifUrl) else { return }
        dataProvider.dowlandImage(url: url) { image in
            self.image = image
        }
    }
    
    func isIndacator(isAnimated: Bool) {
        if isAnimated {
            self.activityIndicat.startAnimating()
            self.activityIndicat.isHidden = false
        } else {
            self.activityIndicat.stopAnimating()
            self.activityIndicat.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
