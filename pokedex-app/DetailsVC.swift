//
//  DetailsVC.swift
//  pokedex-app
//
//  Created by Sagar Arora  on 6/20/16.
//  Copyright © 2016 Sagar Arora . All rights reserved.
//

import UIKit
import Alamofire

class DetailsVC: UIViewController {
    
    var pokemon: Pokemon!

    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var HeightLbl: UILabel!
    @IBOutlet weak var IDlbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var CurrentEvoImg: UIImageView!
    @IBOutlet weak var NextEvoImg: UIImageView!
    @IBOutlet weak var EvoLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IDlbl.text = "\(pokemon.PokemonID)"
        testLabel.text = pokemon.PokemonName.capitalizedString
        pokemonImg.image = UIImage(named: "\(pokemon.PokemonID)")
        pokemon.downloadPokemonDetails {
            self.updateUI()
        // This will be called after download is done. Meaning the function has been completed, thats why you pass in a closure.
        }
        
        
    
    }
    

    func updateUI() {
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.Defense
        HeightLbl.text = pokemon.HeightData
        weightLbl.text = pokemon.WeightData
        attackLbl.text = pokemon.BaseAttack
        CurrentEvoImg.image = UIImage(named: "\(pokemon.PokemonID)")
        if pokemon.nextEvolutionID == "" {
            EvoLbl.text = "NO Evolution"
            NextEvoImg.hidden = true
            
        } else {
        NextEvoImg.hidden = false
        NextEvoImg.image = UIImage(named: "\(pokemon.nextEvolutionID)")
        }
        var str = "Next Evolution: \(pokemon.nextEvolutionText)"
        if pokemon.nextEvolutionLevel != "" {
            str += " LVL \(pokemon.nextEvolutionLevel)"
            EvoLbl.text = str
        } else {
            EvoLbl.text = ""
        }
        
        
        
        
        
        
        
    }
    
    
    
    @IBAction func onBackButtonPressed(sender: AnyObject) {
        
       dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    



}
