//
//  ViewController.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//

import UIKit

class ViewController: BaseTableViewController<PokemonCell,Pokemon> , Bindable {
  
    lazy var searchBar = UISearchBar(frame: .zero)
    private let searchController = UISearchController(searchResultsController: nil)
   // var pokemonViewModel = PokemonManager()
    
    override func viewDidLoad() {
        viewModel = PokemonManager()
        super.viewDidLoad()
       
        bindViewModel()
        self.view.backgroundColor = .white
        //navigationItem.titleView = searchBar
        self.navigationItem.searchController = searchController
         self.navigationItem.hidesSearchBarWhenScrolling = false
    }

    override func loadData() {
        viewModel?.fetchPokemontsList()
    }
    
    func bindViewModel() {
        viewModel?.pokemons.addObserver(observer: self) {[weak self] pokemons in
            self?.items = pokemons
        }
    }
    
    override func handleRefresh() {
        super.handleRefresh()
        viewModel?.pokemons.value.removeAll()
        viewModel?.fetchPokemontsList()
    }
    
    override func cellForRowAt(indexPath: IndexPath,cell:BaseTableViewCell<Pokemon>) {
        guard let cell = cell as? PokemonCell else {return}
        cell.pokemonViewModel = self.viewModel
    }
    
}

