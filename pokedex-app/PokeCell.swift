//
//  PokeCell.swift
//  pokedex-app
//
//  Created by Sagar Arora  on 6/18/16.
//  Copyright © 2016 Sagar Arora . All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    
    var pokemon: Pokemon!
    // store data in all the properties because we need to create objects for each cell.
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    func configureCell(pokemon: Pokemon) {
       self.pokemon = pokemon
        pokemonNameLabel.text = self.pokemon.PokemonName.capitalizedString
        thumbImg.image = UIImage(named: "\(self.pokemon.PokemonID)")
        
        
    }
    
}
