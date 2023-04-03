//
//  AlbumImageCollectionViewCell.swift
//  PhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 15/12/22.
//

import UIKit


class AlbumImageCollectionViewCell: UICollectionViewCell {
    
    let posterSize = CGSize(width: 50, height: 50)
    
    let coverImage = UIImageView()
    let titleLabel = UILabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        titleLabel.font = UIFont.Heading.extraSmall
        titleLabel.textColor = UIColor.Text.charcoal
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byTruncatingTail
                
        coverImage.contentMode = .scaleAspectFit
        coverImage.layer.cornerRadius = 8
        coverImage.layer.masksToBounds = true
        
        
        setupViewsHierarchy()
        setupConstraints()
    }
    
    func setupViewsHierarchy() {
        addSubview(coverImage)
        addSubview(titleLabel)
    }
    
    func setupConstraints() {
        
        coverImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
      
        NSLayoutConstraint.activate([
            
            coverImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverImage.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            coverImage.topAnchor.constraint(equalTo: topAnchor),
            // coverImage.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
            titleLabel.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor,constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor,constant: 0),
            coverImage.widthAnchor.constraint(equalToConstant: posterSize.width).withPriority(999),
            coverImage.heightAnchor.constraint(equalToConstant: posterSize.height).withPriority(999)
        ])
    }
    
    func configure(_ image: PhotoItemModel) {
        
        let imgUrl = "https://picsum.photos/id/" + "\(image.id)" + "/\(50)"
        titleLabel.text = image.author
       // print(image.download_url)
        coverImage.dm_setImage(posterPath: imgUrl)
    }
    
    override func prepareForReuse() {
        coverImage.image = nil
        super.prepareForReuse()
    }
}


extension UICollectionViewCell {
    @objc static var dm_defaultIdentifier: String { return String(describing: self) }
}
