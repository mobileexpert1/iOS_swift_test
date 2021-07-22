//
//  DetailViewController.swift
//  KadamaVnext
//
//  Created by mobile on 22/07/21.
//

import UIKit

class DetailViewController: UIViewController , Bindable{
    
    var pokemon : Pokemon?
    
    var pokemonViewModel = PokemonDetailModel()
    var sections = ["","Types","Abilities","Stats","Moves"]
    
    let loadingIndicator: IndicatorView = {
        let progress = IndicatorView(colors: [.red, .systemGreen, .systemBlue], lineWidth: 8)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        bindViewModel()
        self.title = pokemon?.name?.capitalized
        guard let id = pokemon?.id else {return}
        loadingIndicator.show()
        pokemonViewModel.fetchPokemontsDetails(id: id)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.loadingIndicator.hide()
    }
    
    override func loadView() {
        super.loadView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(SpriteCell.self, forCellReuseIdentifier: "SpriteCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.setupView()
    }
    
    func bindViewModel() {
        pokemonViewModel.pokemonDetail.addObserver(observer: self) { pokemon in
            self.tableView.reloadData()
            self.loadingIndicator.hide()
        }
    }
    
    
    
    func setupView() {
        view.addSubview(tableView)
        tableView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
}

// MARK: UItableview delegates
extension DetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpriteCell", for: indexPath) as! SpriteCell
            cell.imagesURLs = pokemonViewModel.getSprites()
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        switch indexPath.section {
        case 1:
            cell.textLabel?.text = pokemonViewModel.getTypes()
        case 2:
            cell.textLabel?.text = pokemonViewModel.getAbilities()
        case 3:
            cell.textLabel?.text = pokemonViewModel.getStats()
        default:
            cell.textLabel?.text = pokemonViewModel.getMoves()
        }
        
        return cell
    }
    
}
