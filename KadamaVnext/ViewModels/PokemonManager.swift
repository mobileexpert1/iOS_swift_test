//
//  PokemonManager.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//

import Foundation

class PokemonManager : NSObject{
    
    var pokemons : ObserverValue<[Pokemon]> = ObserverValue([])
    var canLoadNext = true
    
    // Fetch all pokemon list
    func fetchPokemontsList() {
        if !canLoadNext {
            return
        }
        PokemonStore.shared.getPokemons(offset:pokemons.value.count,limit: 300) { [weak self] (success, pokemon:PokemonResponse?) in
            if success {
                guard let self = self else {return}
                self.canLoadNext = ((pokemon?.count ?? 0) > self.pokemons.value.count)
                self.pokemons.value.append(contentsOf: pokemon?.results ?? [])
            }
        }
        
    }
    
    // Fetch pokemon details
    func fetchPokemontsDetails(url:String) {
        return;
        guard let id = parsePokemonURL(url: url) else {return}
        PokemonStore.shared.getPokemonDetails(id: String(id)) { [weak self] (success, pokemon:PokemonResponse?) in
            if success {
                guard let self = self else {return}
               
            }
        }
    }
    
    func parsePokemonURL(url:String) -> Substring? {
        let splits = url.split(separator: "/")
        return splits.last
        
    }
}
