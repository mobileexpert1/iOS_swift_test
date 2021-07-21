//
//  PokemonStore.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//

import Foundation
class PokemonStore: ServiceManager {
    
    static let shared = PokemonStore()
    
    // Api for getting pokemons main list
    func getPokemons<T:Codable>(offset:Int = 0,limit:Int = 300,completion:@escaping (_ success:Bool,_ result:T?) -> Void) {
        let url = CONSTANTS.API.POKEMON_LIST + "?offset=\(offset)" + "&limit=\(limit)"
        requestApi(url,completion: completion)
    }
    
    // Api for downloading pokemon details
    func getPokemonDetails<T:Codable>(id:String,completion:@escaping (_ success:Bool,_ result:T?) -> Void) {
        let url = CONSTANTS.API.POKEMON_LIST + "\(id)"
        requestApi(url, completion: completion)
    }
    
}
