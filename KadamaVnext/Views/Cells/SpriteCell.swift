//
//  SpriteCell.swift
//  KadamaVnext
//
//  Created by mobile on 22/07/21.
//

import UIKit

class SpriteCell: UITableViewCell {

    var imagesURLs = [String]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        collectionView.register(SpriteCollectionCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.contentView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:layout )
        collectionView.isScrollEnabled = true
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func setupViews(){
        addSubview(collectionView)
        //addSubview(thumbnailImageView)
       // thumbnailImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, widthConstant: 150, heightConstant: 150)
        collectionView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor,heightConstant: 300)
    }
}

extension SpriteCell : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SpriteCollectionCell
        cell.thumbnailImageView.loadImageUsingUrlString(imagesURLs[indexPath.row])
        return cell
    }
    
}
