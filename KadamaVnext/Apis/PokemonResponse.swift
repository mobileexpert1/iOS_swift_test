//
//  PokemonResponse.swift
//  KadamaVnext
//
//  Created by mobile on 21/07/21.
//

import Foundation


// MARK: - PokemonResponse

struct PokemonResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Pokemon]?
}
