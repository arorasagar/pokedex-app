//
//  Pokemon.swift
//  pokedex-app
//
//  Created by Sagar Arora  on 6/18/16.
//  Copyright © 2016 Sagar Arora . All rights reserved.
//

import Foundation
import Alamofire


class Pokemon {

     private var _PokemonName: String!
     private var _PokemonID: Int!
     private var _Type: String!
     private var _Defense: String!
     private var _HeightData: String!
     private var _WeightData: String!
     private var _BaseAttack: String!
     private var _nextEvolutionTxt: String!
     private var _nextEvolutionID: String!
     private var _description: String!
     private var _pokemonURL: String!
     private var _nextEvolutionLevel: String!
    
    
    
    
    var PokemonName: String {
        
        
        return _PokemonName
        
    }
    
    
    var PokemonID: Int {
        
        return _PokemonID
        
        
    }
    
    var type: String {
        if _Type == nil {
            _Type = ""
        }
        
        return _Type
    }
    
    var Defense: String {
        if _Defense == nil {
            _Defense = ""
        }
        return _Defense
    }
    
    var HeightData: String {
        if _HeightData == nil {
            _HeightData = ""
        }
        
        return _HeightData
    }
    
    var WeightData: String {
        if _WeightData == nil {
            _WeightData = ""
        }
        return _WeightData
    }
    
    var BaseAttack: String {
        if _BaseAttack == nil {
            _BaseAttack = ""
        }
        return _BaseAttack
    }
    
    var nextEvolutionText: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        return _nextEvolutionID
    }
    var nextEvolutionLevel: String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
        }
    
    init(PokemonName: String, PokemonID: Int) {
       self._PokemonName = PokemonName
       self._PokemonID = PokemonID
       self._pokemonURL = "\(base_url)\(url_pokemon)\(self.PokemonID)/"
        
        
        
        
        
        
        }
  
    func downloadPokemonDetails(completed: downloadComplete)  {
        let url = NSURL(string: _pokemonURL)
        Alamofire.request(.GET, url!).responseJSON { (Response: Response<AnyObject, NSError>) in
            let valueData = Response.result.value
            if let dict = valueData as? Dictionary<String, AnyObject> {
                if let weight = dict["weight"] as? String {
                    self._WeightData = weight
                    
                }
                  
                
                if let height = dict["height"] as? String  {
                    self._HeightData = height
                
            }
                if let attack = dict["attack"] as? Int {
                    self._BaseAttack = "\(attack)"
                    
                }
                
                if let defense = dict["defense"] as? Int {
                    
                    self._Defense = "\(defense)"
                }
                

                print(self._WeightData)
                print(self._HeightData)
                print(self._BaseAttack)
                print(self._Defense)
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0  {
                    if let name = types[0]["name"] {
                        self._Type = name.capitalizedString
                        // grabbing the first element and then calling the name. Same as if let type = types[0],
                        // if let name = type["name"]
                    }
                    
                  
                    
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._Type! += "/\(name)".capitalizedString
                                
                            }
                        }
                        
                        
                    
                    }
                    
                    print(self._Type)
                }
                if let descriptionArray = dict["descriptions"] as? [Dictionary<String, String>] where descriptionArray.count > 0 {
                    if let descriptionURL =  descriptionArray[0]["resource_uri"] {
                        if let nsurl = NSURL(string: "\(base_url)\(descriptionURL)") {
                            Alamofire.request(.GET, nsurl).responseJSON { Response in
                                if let descDict = Response.result.value as? Dictionary<String, AnyObject> {
                                    if let description = descDict["description"] as? String  {
                                        self._description = description
                                        print(self._description)
                                    
                                      
                                    }
                                    
                                    
                                }
                                completed()
                                // we are gonna call completed(this is when the labels will change in the Details Controller, 
                                // this is what is going to happen after that function has been completed. We put it here because this will end up being downloaded last because it is a second network request for data. The first one has been called and once it reaches this code it will skip to below as it is downloaded and then it will go through this code once it is downloaded and then at this point all the data has been stored so you can call a completed Closure. 
                            }
                        
                        }
                        
                        
                    
                    
                        
                        
                    
                    }
                    
                       
                      
                        
                     else {
                        self._description = "No Description"
                    }
                    
                    
                }
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String {
                        // cant support megaPokemon now but API still has MegaData. So it will check to see if mega is contained and if it isnt it will continue forward.
                        
                        if to.rangeOfString("mega") == nil {
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                //If you find that part of the string grab it and replace it with nothing. Meaning delete that part of the string.
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                // if target exists replace it with "with string"
                                self._nextEvolutionID = num
                                self._nextEvolutionTxt = to
                                
                            }
                            if let level = evolutions[0]["level"] as? Int {
                                self._nextEvolutionLevel = "\(level)"
                                
                            }
                            print(self._nextEvolutionID)
                            print(self._nextEvolutionTxt)
                            

                        }
                    }
                }
            }
        }
    }
}
