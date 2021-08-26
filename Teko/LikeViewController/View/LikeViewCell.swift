//
//  LikeCollectionViewCell.swift
//  Teko
//
//  Created by admin on 23.08.2021.
//

import UIKit

final class LikeViewCell: UICollectionViewCell {
    
//MARK: - @IBOutlets
    @IBOutlet var checkMark: UIImageView!
    @IBOutlet var activityIndic: UIActivityIndicatorView!
    @IBOutlet var likeImageView: UIImageView!
    
//MARK: - Properties
    static let reuseId = "LikeViewCell"
    private var dataProvider = DataProviderImage()
    
    private var image: UIImage? {
        didSet {
            likeImageView.image = image
            isIndacator(isAnimated: false)
        }
    }
    
    override var isSelected: Bool {
        didSet{
            updateState()
        }
    }
//MARK: - Life Cycle
    override func prepareForReuse() {
        super.prepareForReuse()

        likeImageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        config()
    }
//MARK:- Config
    private func config() {
        checkMark.alpha = 0
        likeImageView.contentMode = .scaleAspectFit
        isIndacator(isAnimated: true)
    }
//MARK: - Functions
    
    private func updateState() {
        likeImageView.alpha = isSelected ? 0.7 : 1
        checkMark.alpha = isSelected ? 1 : 0
    }
    
    func set(gif: Gifs) {
        let gifUrl = gif.urlGifs
        guard let url = URL(string: gifUrl) else { return }
        dataProvider.dowlandImage(url: url) { image in
            self.image = image
        }
    }
    
    private func isIndacator(isAnimated: Bool) {
        if isAnimated {
            activityIndic.startAnimating()
            activityIndic.isHidden = false
        } else {
            activityIndic.stopAnimating()
            activityIndic.isHidden = true
        }
    }
}
