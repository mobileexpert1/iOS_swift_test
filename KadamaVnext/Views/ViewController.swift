//
//  ViewController.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//

import UIKit

class ViewController: BaseTableViewController<PokemonCell,Pokemon> , Bindable {
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Properties
    let loadingIndicator: IndicatorView = {
        let progress = IndicatorView(colors: [.red, .systemGreen, .systemBlue], lineWidth: 8)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    override func viewDidLoad() {
        viewModel = PokemonManager()
        bindViewModel()
        super.viewDidLoad()
        self.title = "Pokemon"
        self.view.backgroundColor = UIColor.systemBackground
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        
        let filterBtn = UIBarButtonItem(image: UIImage.init(systemName: "arrow.up.arrow.down.circle.fill"), style: .plain, target: self, action: #selector(sortPokemons))
        self.navigationItem.rightBarButtonItem  = filterBtn
    }
    
    override func loadData() {
        viewModel?.fetchPokemontsList()
    }
    
    func bindViewModel() {
        
        viewModel?.pokemons.addObserver(observer: self) {[weak self] pokemons in
            self?.items = pokemons
            self?.viewModel?.showActivity.value = false
        }
        viewModel?.showActivity.addObserver(observer: self, completionHandler: { [weak self] show in
            if show{
                self?.loadingIndicator.show()
            }
            else {
                self?.loadingIndicator.hide()
            }
        })
    }
    
    override func handleRefresh() {
        super.handleRefresh()
        viewModel?.pokemons.value.removeAll()
        viewModel?.pokemonsStorage.value.removeAll()
        viewModel?.fetchPokemontsList()
    }
    
    // Assign all cells common viewmodel
    override func cellForRowAt(indexPath: IndexPath,cell:BaseTableViewCell<Pokemon>) {
        guard let cell = cell as? PokemonCell else {return}
        cell.pokemonViewModel = self.viewModel
    }
    
    override func didSelectRowAt(indexPath: IndexPath) {
        guard (self.viewModel?.pokemons.value.count)! > indexPath.row else{return}
        let controller = DetailViewController()
        controller.pokemon = self.viewModel?.pokemons.value[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // Sorting pokemonds
    @objc func sortPokemons(){
        viewModel?.togglePokemomSorting()
    }
    
}

extension ViewController : UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel?.searchPokemon(string: "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                // searchBar.resignFirstResponder()
            }
        }
        print(searchText)
        self.viewModel?.searchPokemon(string: searchText)
    }
    
}
