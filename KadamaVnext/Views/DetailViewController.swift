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
    var sections = ["Types","Abilities","Stats","Moves"]
    
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
        pokemonViewModel.fetchPokemontsDetails(id: id)
    }
    
    override func loadView() {
        super.loadView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.delegate = self
        tableView.dataSource = self
        self.setupView()
    }
    
    func bindViewModel() {
        pokemonViewModel.pokemonDetail.addObserver(observer: self) { pokemon in
            self.tableView.reloadData()
        }
    }
    

    
    func setupView() {
        view.addSubview(tableView)
        tableView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: UItableview delegates
extension DetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = pokemonViewModel.getTypes()
        case 1:
            cell.textLabel?.text = pokemonViewModel.getAbilities()
        case 2:
            cell.textLabel?.text = pokemonViewModel.getStats()
        default:
            cell.textLabel?.text = pokemonViewModel.getMoves()
        }
      
        return cell
    }
    
}
