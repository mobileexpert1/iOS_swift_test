//
//  PokemonManager.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//

import Foundation

class PokemonManager : NSObject{
    
    enum SortBy {
        case number
        case name
    }
    
    var pokemons : ObserverValue<[Pokemon]> = ObserverValue([])
    var pokemonsStorage : ObserverValue<[Pokemon]> = ObserverValue([])
    var showActivity : ObserverValue<Bool> = ObserverValue(false)
    var sortBy : ObserverValue<SortBy> = ObserverValue(SortBy.number)
    var canLoadNext = true
    var persistantStore = PersistanceStore()
    
    
    // Fetch all pokemon list
    func fetchPokemontsList() {
        showActivity.value = true
        let localRecords = persistantStore.fetchAllPokemons()
        if ((localRecords.count) > 0) && (pokemonsStorage.value.count < localRecords.count) {
            loadLocalPokemons()
            return;
        }
        if !canLoadNext {
            return
        }
        PokemonStore.shared.getPokemons(offset:pokemons.value.count,limit: 300) { [weak self] (success, pokemon:PokemonResponse?) in
            if success {
                guard let self = self else {return}
                self.canLoadNext = ((pokemon?.count ?? 0) > self.pokemons.value.count)
                self.savePokemonsToLocal(pokemons: pokemon?.results ?? [])
                self.pokemons.value.append(contentsOf: pokemon?.results ?? [])
                self.pokemonsStorage.value.append(contentsOf: pokemon?.results ?? [])
            }
            else{
                self?.showActivity.value = false
            }
        }
    }
    
    // Save all pokemons to core data
    func savePokemonsToLocal(pokemons:[Pokemon]){
        for pokemon in pokemons {
            self.persistantStore.savePokemon(pokemon: pokemon)
        }
        let test = self.persistantStore.fetchAllPokemons()
        print(test)
    }
    
    // Save load local pokemons
    func loadLocalPokemons(){
        var pokemonsList = [Pokemon]()
        let allPokemons = self.persistantStore.fetchAllPokemons()
        for detail in allPokemons {
            let pokemon = Pokemon(name: detail.name , url: detail.url, abilities: nil, sprites: nil, id: Int(detail.id ?? "0") ,image: detail.image,abilitiesString: detail.abilities)
            pokemonsList.append(pokemon)
        }
        self.pokemons.value = pokemonsList
        self.pokemonsStorage.value = pokemonsList
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
        PokemonStore.shared.getPokemonDetails(id: pokemonID) { [weak self] (success, pokemonDetail:Pokemon?) in
            if success {
                guard let self = self , let poke = pokemonDetail else {return}
                var updatedPokemon = poke
                updatedPokemon.url = pokemon.url
                self.persistantStore.savePokemon(pokemon: updatedPokemon)
                self.updatePokemonDetail(pokemon: updatedPokemon)
            }
        }
    }
    
    // Update image and abilities of pokemon if does not exits
    func updatePokemonDetail(pokemon:Pokemon){
        
        if let detail = persistantStore.fetchPokemon(id: "\(pokemon.id ?? 0)") {
            let updatedPokemon = Pokemon(name: detail.name , url: detail.url, abilities: nil, sprites: nil, id: Int(detail.id ?? "0") ,image: detail.image,abilitiesString: detail.abilities)
            if let index =  self.pokemonsStorage.value.firstIndex(where: { current in
                if let id = parsePokemonURL(url: current.url ?? "") {
                    return "\(updatedPokemon.id ?? 0)" == id
                }
                else if let id = current.id {
                    return (updatedPokemon.id ?? 0) == id
                }
                return false
            }) {
                if (pokemonsStorage.value.count > index){
                    self.pokemonsStorage.value[index] = updatedPokemon
                }
                if (pokemons.value.count > index){
                    self.pokemons.value[index] = updatedPokemon
                }
            }
        }
        
        
    }
    
    // parsing pokemond url to get the id of the pokemon as api only return name and url
    func parsePokemonURL(url:String) -> Substring? {
        let splits = url.split(separator: "/")
        return splits.last
    }
    
    // Toggle sorting
    func togglePokemomSorting(){
        switch sortBy.value {
        case .number:
            sortByName()
            sortBy.value = .name
        case .name:
            sortByNumber()
            sortBy.value = .number
        }
        
    }
    
    // Sort pokemons by their id
    private func sortByNumber(){
        self.pokemons.value =  self.pokemons.value.sorted { (first, second) in
            guard let first = first.id , let second = second.id else {return false}
           return first < second
        }
        self.pokemonsStorage.value =  self.pokemonsStorage.value.sorted { (first, second) in
            guard let first = first.id , let second = second.id else {return false}
           return first < second
        }
    }
    
    // Sort pokemons by their name
    private func sortByName(){
        self.pokemons.value =  self.pokemons.value.sorted { (first, second) in
            guard let first = first.name , let second = second.name else {return false}
           return first < second
        }
        self.pokemonsStorage.value =  self.pokemonsStorage.value.sorted { (first, second) in
            guard let first = first.name , let second = second.name else {return false}
           return first < second
        }
    }
    
    
    // Search pokemons locally
    func searchPokemon(string:String){
        if (string.isEmpty){
            // if empty , no change required
            self.pokemons.value = self.pokemonsStorage.value
            return
        }
        let filtered = self.pokemonsStorage.value.filter { pokemon in
            let nameMatch = (pokemon.name?.lowercased().contains(string.lowercased())) ?? false
            let abilitiesMatch = (pokemon.abilitiesString?.lowercased().contains(string.lowercased())) ?? false
            return ( nameMatch || abilitiesMatch)
        }
        self.pokemons.value = filtered
    }
    
}
