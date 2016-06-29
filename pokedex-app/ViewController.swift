//
//  ViewController.swift
//  pokedex-app
//
//  Created by Sagar Arora  on 6/17/16.
//  Copyright © 2016 Sagar Arora . All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var pokemonCollectionview: UICollectionView!
    @IBOutlet weak var SearchBar: UISearchBar! 
    
    
    var pokemonArray = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    var filteredPokemon = [Pokemon]()
    var inDetailsVC = false


    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonCollectionview.delegate = self
        pokemonCollectionview.dataSource = self
        SearchBar.delegate = self
        SearchBar.returnKeyType = UIReturnKeyType.Done

        parsePokemonCSV()
        initAudio()
        
  
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initAudio() {
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
            
        } catch let error as NSError {
            
            print(error.debugDescription)
        }
        
    }
    // reference the file using the path and then pass in that path to the AudioPlayer.
    
    @IBAction func onMusicButtonPressed(Sender: UIButton!) {
        if musicPlayer.playing {
            musicPlayer.stop()
            Sender.alpha = 0.2
        } else {
           musicPlayer.play()
            Sender.alpha = 1.0
            
        }
        
        
    }
    

    func parsePokemonCSV() {
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
             // creating a path reference to that file and parse the CSV file meaning convert it so we can acess the rows and properties.
            for row in rows {
                 let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(PokemonName: name, PokemonID: pokeId)
               
                
                   // Referencing the id key in each row and setting it equal to pokeId.
                    // Rows is equal to all the rows of data in the CSV file. The different id's identifiers, types etc.
                // grabbing the pokeId and identifier value and storing them into the pokemon properties.
                pokemonArray.append(poke)
             
                
            }
            
           
            
        } catch let err as NSError  {
            print(err.debugDescription)
            
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
             return filteredPokemon.count
            
        }
        return pokemonArray.count
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
            performSegueWithIdentifier("goToDetails", sender: poke)
            
           
            
        }
        
        else {
          poke = pokemonArray[indexPath.row]
          performSegueWithIdentifier("goToDetails", sender: poke)
            
            
        }
        
    }
   
    
   
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = pokemonCollectionview.dequeueReusableCellWithReuseIdentifier("pokemonCell", forIndexPath: indexPath) as? PokeCell {
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
                
            } else {
                
                poke = pokemonArray[indexPath.row]
                
            }
       
            
            cell.configureCell(poke)
            
         return cell
            
        } else {
        return UICollectionViewCell()
        }
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSizeMake(105, 105)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if SearchBar.text == nil || SearchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            pokemonCollectionview.reloadData()
            
            // If there is nothing in the text bar/ text is deleted then searchMode is now false close the editing and reloadtheData so it can load the PokemonArray Cells.
   
            
        } else {
            
          inSearchMode = true
          let lower = searchBar.text!.lowercaseString
            filteredPokemon = pokemonArray.filter({$0.PokemonName.rangeOfString(lower) != nil})
            // the filter function filters an array. In this case it is filtering the pokemon array of objects and the filter used is the pokemon Name. The objects in the array  now going to equal the objects with that filter 
            pokemonCollectionview.reloadData()
            /*  stores the pokemon(s) that has the letters/string that you passed into the filter into an filtered array. Pretend that the $0 is the same thing as referencing a pokemon object in an array and grabbing it and then being able to acess its properties. The filter function filters the array of data based on what string is passed in the filter function.
                Lets check this pokemon object and grab its name and then use the names of the pokemon objects
                to filter out the data. rangeOfString is a function that checks to see if the string passed in is contained in any of the PokemonNames. Example: type in zard, checks to see if that rangeofstring characters is contained in any of the names. If the range is not equal to nil meaning the string exists on the specific referenced pokemonName it is going to add that to the filtered Pokemon Array. Now when in search mode the array of data that is going to be displayed is going to be the pokemons that have been added to the filter, if it isnt in searchmode it is just going to show all the pokemon. If it is in search mode it is going to display the filtered Array count otherwise its going to display the regular pokemon array count.   */
                
            
          
            
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToDetails" {
            if let DetailsVC = segue.destinationViewController as? DetailsVC {
                let poke = sender as? Pokemon
                DetailsVC.pokemon = poke
                
                
                
            }
            
            
        }
    }
    // You must cast it because the DestinationViewController returns just a regular View Controller so cast it as a DetailsVC
    // the sender is any object so you must cast as a Pokemon Object type. Reference the pokemon object in the details VC and then store that data of the sender euqal to the pokemon Object in the DetailsVC.
    

    
    
    


}

