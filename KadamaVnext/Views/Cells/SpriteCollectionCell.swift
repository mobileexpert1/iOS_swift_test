//
//  SpriteCollectionCell.swift
//  KadamaVnext
//
//  Created by mobile on 22/07/21.
//

import UIKit

class SpriteCollectionCell: UICollectionViewCell {
    
    let thumbnailImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(thumbnailImageView)
        thumbnailImageView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor,right: contentView.rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
