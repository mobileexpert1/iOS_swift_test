//
//  ViewController.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//

import UIKit

class ViewController: UIViewController , Bindable {
  
    var pokemonViewModel = PokemonManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        pokemonViewModel.fetchPokemontsList()
    }

    func bindViewModel() {
        pokemonViewModel.pokemons.addObserver(observer: self) { pokemons in
            print(pokemons)
        }
    }
    
    
}


