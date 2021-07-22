//
//  PokemonCell.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//

import Foundation
import UIKit

class PokemonCell: BaseTableViewCell<Pokemon> {
  
    var pokemonViewModel : PokemonManager?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var item: Pokemon! {
        didSet {
            self.loadData()
        }
    }
    
    func loadData(){
        guard let viewModel = pokemonViewModel else {return}
        viewModel.fetchPokemontsDetails(pokemon: item )
        titleLabel.text = item?.name?.capitalized
        guard let image = item?.image else {
            if let id = parsePokemonURL(url: item?.url ?? "") {
                let url = CONSTANTS.API.IMAGE_BASE_URL + "\(id).png"
                // By assurance that url will be the same always otherwise this static check will fail
                thumbnailImageView.loadImageUsingUrlString(url)
            }
            return
        }
        thumbnailImageView.loadImageUsingUrlString(image)
        guard let abilities = item?.abilitiesString else {
            return
        }
        abilitiesLabel.text = abilities
    }
    
   
    let thumbnailImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Pokemon"
        label.numberOfLines = 2
        return label
    }()
    
    let abilitiesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = ""
        label.numberOfLines = 3
        return label
    }()
    
    func setupViews(){
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        addSubview(abilitiesLabel)
        thumbnailImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, widthConstant: 150, heightConstant: 150)
        titleLabel.anchor(thumbnailImageView.topAnchor, left: thumbnailImageView.rightAnchor,right: self.rightAnchor, topConstant: 10, leftConstant: 10, rightConstant: 10)
        abilitiesLabel.anchor(titleLabel.bottomAnchor,left: titleLabel.leftAnchor,right: self.rightAnchor, topConstant: 10, rightConstant: 10)
    }
    
    func parsePokemonURL(url:String) -> Substring? {
        let splits = url.split(separator: "/")
        return splits.last
    }
    
}
