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
    var persistantStore = PersistanceStore()
    // Fetch all pokemon list
    func fetchPokemontsList() {
        
        loadLocalPokemons()
        return;
        
        if !canLoadNext {
            return
        }
        PokemonStore.shared.getPokemons(offset:pokemons.value.count,limit: 300) { [weak self] (success, pokemon:PokemonResponse?) in
            if success {
                guard let self = self else {return}
                self.canLoadNext = ((pokemon?.count ?? 0) > self.pokemons.value.count)
                self.savePokemonsToLocal(pokemons: pokemon?.results ?? [])
                self.pokemons.value.append(contentsOf: pokemon?.results ?? [])
            }
        }
        
    }
    
    func savePokemonsToLocal(pokemons:[Pokemon]){
        for pokemon in pokemons {
            self.persistantStore.savePokemon(pokemon: pokemon)
        }
        let test = self.persistantStore.fetchAllPokemons()
        print(test)
    }
    
    func loadLocalPokemons(){
        var pokemonsList = [Pokemon]()
        let allPokemons = self.persistantStore.fetchAllPokemons()
        for detail in allPokemons {
            let pokemon = Pokemon(name: detail.name , url: detail.url, abilities: nil, sprites: nil, id: Int(detail.id ?? "0") ,image: detail.image)
            pokemonsList.append(pokemon)
        }
        self.pokemons.value = pokemonsList
    }
    
    
    // Fetch pokemon details
    func fetchPokemontsDetails(pokemon:Pokemon) {
        
        var pokemonID = ""
        if let id = parsePokemonURL(url: pokemon.url ?? "") {
            pokemonID = String(id)
        }
        else if let id = pokemon.id {
            pokemonID = "\(id)"
        }
        print(pokemonID)
        
        if (persistantStore.doesPokemonExist(id:pokemonID)){
            print("exists")
            return;
        }
        PokemonStore.shared.getPokemonDetails(id: pokemonID) { [weak self] (success, pokemon:Pokemon?) in
            if success {
                guard let self = self , let pokemon = pokemon else {return}

                self.persistantStore.savePokemon(pokemon: pokemon)
            }
        }
    }
    
    func parsePokemonURL(url:String) -> Substring? {
        let splits = url.split(separator: "/")
        return splits.last
    }
    
}
