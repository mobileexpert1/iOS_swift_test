//
//  PokemonDetailViewModel.swift
//  KadamaVnext
//
//  Created by mobile on 22/07/21.
//

import Foundation

class PokemonDetailModel : NSObject{
    
    var pokemonDetail : ObserverValue<PokemonInfo?> = ObserverValue(nil)
    
    func fetchPokemontsDetails(id:Int) {

        PokemonStore.shared.getPokemonDetails(id: "\(id)") { [weak self] (success, pokemonDetail:PokemonInfo?) in
            if success {
                guard let self = self , let poke = pokemonDetail else {return}
                self.pokemonDetail.value = poke
            }
        }
    }
    
    func getMoves() -> String {
        guard let detail = pokemonDetail.value else {return "No moves"}
        let string = detail.moves?.map({($0.move?.name ?? "").capitalized}).joined(separator: ", ")
        return string ?? "No moves"
    }
    
    func getStats() -> String {
        guard let detail = pokemonDetail.value else {return "No stats"}
        let string = detail.stats?.map({
            let baseStat = "\($0.baseStat ?? 0)"
            let name = $0.stat?.name.capitalized ?? ""
            return baseStat + " : " + name
        }).joined(separator: "\n")
        return string ?? "No stats"
    }
    
    func getTypes() -> String {
        guard let detail = pokemonDetail.value else {return "No Types"}
        let string = detail.types?.map({($0.type?.name ?? "").capitalized}).joined(separator: ", ")
        return string ?? "No Types"
    }
    
    func getAbilities() -> String {
        guard let detail = pokemonDetail.value else {return "No Abilities"}
        let string = detail.abilities?.map({($0.ability.name ).capitalized}).joined(separator: ", ")
        return string ?? "No Abilities"
    }
}
