//
//  Pokemon.swift
//  Poke iOS
//
//  Created by Davin Djayadi on 29/08/22.
//

import Foundation
import UIKit

import Foundation

struct Pokemon: Codable {
    let abilities: [Pokemon__Ability]
    let height, id: Int
    let name: String
    let sprites: Pokemon__Sprites
    let types: [Pokemon__Type]
    let weight: Int
    
    var idDisplay: String{
        String(format: "%03d", id)
    }
    var typesDisplay: String {
        types.map{ $0.type.name }.joined(separator:" . ")
    }
    var imageUrl: String{
        self.sprites.other.officialArtwork.frontDefault
    }
    
    static func getPokemonById(idPokemon: Int, oncompletion: @escaping (Pokemon)->Void){
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(idPokemon)")!
        let task = URLSession.shared.dataTask(with: url){ [oncompletion] (data, response, error) in
            if let error = error {
                print("Error fetching pokemon \(error)") // TODO handle error fetching pokemon
            }
            if let data = data, let pokemon = try? JSONDecoder().decode(Pokemon.self, from: data) {
                oncompletion(pokemon)
            }
        }
        task.resume()
    }
}

struct Pokemon__Ability: Codable {
    let ability: Pokemon__AttributeDetail
}

struct Pokemon__AttributeDetail: Codable {
    let name: String
}

struct Pokemon__Sprites: Codable {
    let other: Pokemon__SpritesOther
}

struct Pokemon__SpritesOther: Codable {
    let officialArtwork: Pokemon__SpritesOtherOfficialArtwork

    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct Pokemon__SpritesOtherOfficialArtwork: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct Pokemon__Type: Codable {
    let slot: Int
    let type: Pokemon__AttributeDetail
}

