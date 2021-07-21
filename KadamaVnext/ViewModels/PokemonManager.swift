//
//  PokemonManager.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//

import Foundation

class PokemonManager : NSObject{
    
    var pokemons : ObserverValue<[Pokemon]> = ObserverValue([])
    
    func fetchPokemontsList() {
        PokemonStore.shared.getPokemons(limit: 10) { [weak self] (success, pokemon:PokemonResponse?) in
            if success {
                self?.pokemons.value = pokemon?.results ?? []
            }
        }
        
    }
    
}
