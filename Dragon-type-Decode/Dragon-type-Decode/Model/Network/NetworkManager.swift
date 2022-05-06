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
        let fileName = "DragonsRaw"
        guard let path = Bundle.main.path(forResource: fileName, ofType: "JSON") else {
            print("Path not found.")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: url)
            let dragons = try JSONDecoder().decode(Dragons.self, from: data)
            return dragons
        } catch {
            print(error)
        }
        return nil
    }
    
    func parseDragonsManually(baseDict: [String: Any]) -> Dragons? {
        // Damage Relations
        guard let damageDict = baseDict["damage_relations"] as? [String: Any] else {
            print("Failed: DamageRelations")
            return nil
        }
        var damage_relations: [DamageRelations] = []
        damageDict.forEach {_ in
            guard let ddfromArr = damageDict["double_damage_from"] as? [[String: Any]] else { return }
            var returnddfromArr: [BasicData] = []
            ddfromArr.forEach {
                guard let basicData = self.createBasicData(dict: $0) else { return }
                returnddfromArr.append(basicData)
            }
            guard let ddtoArr = damageDict["double_damage_to"] as? [[String: Any]] else { return }
            var returnddtoArr: [BasicData] = []
            ddtoArr.forEach {
                guard let basicData = self.createBasicData(dict: $0) else { return }
                returnddtoArr.append(basicData)
            }
            // HD to-from
            guard let hdfromArr = damageDict["half_damage_from"] as? [[String: Any]] else { return }
            var returnhdfromArr: [BasicData] = []
            hdfromArr.forEach {
                guard let basicData = self.createBasicData(dict: $0) else { return }
                returnhdfromArr.append(basicData)
            }
            guard let hdtoArr = damageDict["half_damage_to"] as? [[String: Any]] else { return }
            var returnhdtoArr: [BasicData] = []
            hdtoArr.forEach {
                guard let basicData = self.createBasicData(dict: $0) else { return }
                returnhdtoArr.append(basicData)
            }
            // ND to-from
            guard let ndfromArr = damageDict["no_damage_from"] as? [[String: Any]] else { return }
            var returnndfromArr: [BasicData] = []
            ndfromArr.forEach {
                guard let basicData = self.createBasicData(dict: $0) else { return }
                returnndfromArr.append(basicData)
            }
            guard let ndtoArr = damageDict["no_damage_to"] as? [[String: Any]] else { return }
            var returnndtoArr: [BasicData] = []
            ndtoArr.forEach {
                guard let basicData = self.createBasicData(dict: $0) else { return }
                returnndtoArr.append(basicData)
            }
            damage_relations.append(DamageRelations(ddfrom: returnddfromArr, ddto: returnddtoArr, hdfrom: returnhdfromArr, hdto: returnhdtoArr, ndfrom: returnndfromArr, ndto: returnndtoArr))
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
            gameIndeces.append(GameIndex(game_index: gameIndex, generation: generation))
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
            pokemon.append(Pokemon(pokemon: pokemans, slot: slot))
        }
        
        return Dragons(game_indices: gameIndeces, generation: dragonGen, id: dragonID, move_damage_class: md_class, moves: [moves], name: name, pokemon: pokemon)
    }
    
    func createBasicData(dict: [String:Any]) -> BasicData? {
        guard let name = dict["name"] as? String else { return nil }
        guard let url = dict["url"] as? String else { return nil }
        return BasicData(name: name, url: url)
    }
}
