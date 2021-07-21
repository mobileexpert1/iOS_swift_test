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
        bindViewModel()
        super.viewDidLoad()
        self.title = "Pokemon"
        self.view.backgroundColor = .white
        //navigationItem.titleView = searchBar
        self.navigationItem.searchController = searchController
         self.navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
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

extension ViewController : UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if !(searchBar.searchTextField.text?.isEmpty ?? true){
//            guard let searchText = searchBar.text else {return}
//            let trimmedPhoneNumber = String(searchText.filter { !" \n\t\r".contains($0) })
//            let finalTrimmedPhoneNumber = trimmedPhoneNumber.stripped
//            self.searchViewModel.searchUser(number: (finalTrimmedPhoneNumber.isEmpty) ? searchText : finalTrimmedPhoneNumber)
//        }
//        searchBar.resignFirstResponder()
//    }
    
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
