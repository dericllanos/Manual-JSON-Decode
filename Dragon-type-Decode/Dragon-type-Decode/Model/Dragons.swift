//
//  DragonModel.swift
//  Dragon-type-Decode
//
//  Created by Frederic Rey Llanos on 05/05/2022.
//

import Foundation

struct Dragons {
    var damage_relations: [DamageRelations]
    var game_indeces: [GameIndex]
    var generation: BasicData
    var id: Int
    var md_class: BasicData
    var moves: BasicData
    var name: String
    var pokemon: [Pokemon]
}

struct DamageRelations {
    var ddfrom: BasicData
    var ddto: BasicData
    var hdfrom: BasicData
    var hdto: BasicData
    var ndfrom: BasicData
    var ndto: BasicData
}

struct GameIndex {
    var gameIndex: Int
    var generation: BasicData
}

struct Pokemon {
    var pokemans: BasicData
    var slot: Int
}

struct BasicData {
    var name: String
    var url: String
}


