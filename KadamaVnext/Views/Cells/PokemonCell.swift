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
    
    override var item: Pokemon! {
        didSet {
            self.loadData()
        }
    }
    
    func loadData(){
        guard let viewModel = pokemonViewModel else {return}
        viewModel.fetchPokemontsDetails(url: item?.url ?? "")
        titleLabel.text = item?.name?.capitalized
        thumbnailImageView.loadImageUsingUrlString("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "Pokemon"
        label.numberOfLines = 2
        return label
    }()
    
    func setupViews(){
        addSubview(thumbnailImageView)
        addSubview(titleLabel)
        thumbnailImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, topConstant: 10, leftConstant: 10, bottomConstant: 10, widthConstant: 150, heightConstant: 150)
        titleLabel.anchor(thumbnailImageView.topAnchor, left: thumbnailImageView.rightAnchor,right: self.rightAnchor, topConstant: 10, leftConstant: 10, rightConstant: 10)
    }
    
}
