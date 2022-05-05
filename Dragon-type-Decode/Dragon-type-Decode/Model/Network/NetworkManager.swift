//
//  NetworkManager.swift
//  Dragon-type-Decode
//
//  Created by Frederic Rey Llanos on 05/05/2022.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    func getDragonsManually() -> Dragons? {
        guard let path = Bundle.main.path(forResource: "Dragons_Raw", ofType: "json") else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let jsonObj = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            guard let baseDict = jsonObj as? [String: Any] else { return nil }
            return parseDragonsManually(baseDict: baseDict)
        } catch {
            print(error)
        }
        return nil
    }
    
    func parseDragonsManually(baseDict: [String: Any]) -> Dragons? {
        // Damage Relations
        guard let damageArr = baseDict["damage_relations"] as? [[String: Any]] else {
            print("Failed: DamageRelations")
            return nil
        }
        var actualDamage: [DamageRelations] = []
        damageArr.forEach {
            guard let damageDict = $0["double_damage_from"] as? [String: Any] else {
                print("Failed: double_damage_from")
                return
            }
            guard let ddfrom = self.createBasicData(dict: damageDict) else {
                return
            }
            guard let damageDict = $0["double_damage_to"] as? [String: Any] else {
                print("Failed: double_damage_to")
                return
            }
            guard let ddto = self.createBasicData(dict: damageDict) else {
                return
            }
            guard let damageDict = $0["half_damage_from"] as? [String: Any] else {
                print("Failed: half_damage_from")
                return
            }
            guard let hdfrom = self.createBasicData(dict: damageDict) else {
                return
            }
            guard let damageDict = $0["half_damage_to"] as? [String: Any] else {
                print("Failed: half_damage_to")
                return
            }
            guard let hdto = self.createBasicData(dict: damageDict) else {
                return
            }
            guard let damageDict = $0["no_damage_from"] as? [String: Any] else {
                print("Failed: no_damage_from")
                return
            }
            guard let ndfrom = self.createBasicData(dict: damageDict) else {
                return
            }
            guard let damageDict = $0["no_damage_to"] as? [String: Any] else {
                print("Failed: no_damage_to")
                return
            }
            guard let ndto = self.createBasicData(dict: damageDict) else {
                return
            }
            actualDamage.append(DamageRelations(ddfrom: ddfrom, ddto: ddto, hdfrom: hdfrom, hdto: hdto, ndfrom: ndfrom, ndto: ndto))
        }
        
        // Game Indeces
        guard let gameIndecesArr = baseDict["game_indices"] as? [[String: Any]] else {
            return nil
        }
        var gameIndeces: [GameIndex] = []
        gameIndecesArr.forEach {
            guard let gameIndex = $0["game_index"] as? Int else { return }
            guard let gameGen = $0["generation"] as? [String: Any] else { return }
            guard let generation = self.createBasicData(dict: gameGen) else { return }
            gameIndeces.append(GameIndex(gameIndex: gameIndex, generation: generation))
        }
        
        // Game Generation
        guard let dragonGenDict = baseDict["generation"] as? [String: Any] else { return nil }
        guard let dragonGen = self.createBasicData(dict: dragonGenDict) else { return nil }
        
        // ID
        guard let dragonID = baseDict["id"] as? Int else { return nil }
        
        // Move Damage Class
        guard let md_classDict = baseDict["move_damage_class"] as? [String: Any] else { return nil }
        guard let md_class = self.createBasicData(dict: md_classDict) else { return nil }
        
        // Moves
        guard let movesDict = baseDict["moves"] as? [String: Any] else { return nil }
        guard let moves = self.createBasicData(dict: movesDict) else { return nil }
        
        // Name
        guard let name = baseDict["name"] as? String else { return nil }
        
        // Pokemon
        guard let pokemonArr = baseDict["pokemon"] as? [[String: Any]] else {
            return nil
        }
        var pokemon: [Pokemon] = []
        pokemonArr.forEach {
            guard let pokemansDict = $0["pokemon"] as? [String:Any] else { return }
            guard let pokemans = self.createBasicData(dict: pokemansDict) else { return }
            guard let slot = $0["slot"] as? Int else { return }
            pokemon.append(Pokemon(pokemans: pokemans, slot: slot))
        }
        
        return Dragons(damage_relations: actualDamage, game_indeces: gameIndeces, generation: dragonGen, id: dragonID, md_class: md_class, moves: moves, name: name, pokemon: pokemon)
    }
    
    func createBasicData(dict: [String:Any]) -> BasicData? {
        guard let name = dict["name"] as? String else { return nil }
        guard let url = dict["url"] as? String else { return nil }
        return BasicData(name: name, url: url)
    }
}
