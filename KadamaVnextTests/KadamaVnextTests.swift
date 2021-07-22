//
//  KadamaVnextTests.swift
//  KadamaVnextTests
//
//  Created by mobile on 21/07/21.
//

import XCTest
@testable import KadamaVnext

class KadamaVnextTests: XCTestCase {

    let persistantStore = PersistanceStore()
    let pokemons : ObserverValue<[Pokemon]> = ObserverValue([])
    let pokemonsStorage : ObserverValue<[Pokemon]> = ObserverValue([])
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
     let idString = parsePokemonURL(url: "https://pokeapi.co/api/v2/pokemon/1/")
        XCTAssertNotNil(idString)
        loadLocalPokemons()
        
        let pokemon1 = Pokemon(name: "test" , url: "https://pokeapi.co/api/v2/pokemon/1/", abilities: nil, sprites: nil, id: 1 ,image: "",abilitiesString: "")
        let pokemon2 = Pokemon(name: "test" , url: nil, abilities: nil, sprites: nil, id: nil ,image: "",abilitiesString: "")
        fetchPokemontsDetails(pokemon: pokemon1)
        fetchPokemontsDetails(pokemon: pokemon2)
        
        
        
           searchPokemon(string: "test")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func parsePokemonURL(url:String) -> Substring? {
        let splits = url.split(separator: "/")
        return splits.last
    }
    

    func loadLocalPokemons(){
      
        var pokemonsList = [Pokemon]()
        let allPokemons = persistantStore.fetchAllPokemons()
        for detail in allPokemons {
            let pokemon = Pokemon(name: detail.name , url: detail.url, abilities: nil, sprites: nil, id: Int(detail.id ?? "0") ,image: detail.image,abilitiesString: detail.abilities)
            XCTAssertNotNil(nil)
            pokemonsList.append(pokemon)
        }
        pokemons.value = pokemonsList
        pokemonsStorage.value = pokemonsList
    }
    
    func fetchPokemontsDetails(pokemon:Pokemon) {
        var pokemonID = ""
        if let id = parsePokemonURL(url: pokemon.url ?? "") {
            pokemonID = String(id)
        }
        else if let id = pokemon.id {
            pokemonID = "\(id)"
        }
        print(pokemonID)
        XCTAssertTrue(!pokemonID.isEmpty)
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
            }
        }
    }
    
    
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
