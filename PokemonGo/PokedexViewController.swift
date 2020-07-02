//
//  PokedexViewController.swift
//  PokemonGo
//
//  Created by mbtec22 on 6/25/20.
//  Copyright © 2020 mbtec22. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pokemonAtrapados.count
        } else {
            return pokemonNoAtrapados.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon : Pokemon
        if indexPath.section == 0 {
            pokemon = pokemonAtrapados[indexPath.row]
        } else {
            pokemon = pokemonNoAtrapados[indexPath.row]
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = pokemon.nombre
        cell.imageView?.image = UIImage(named: pokemon.imagenNombre!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Atrapados"
        } else {
            return "No Atrapados"
        }
    }
    
    var pokemonAtrapados:[Pokemon] = []
    var pokemonNoAtrapados:[Pokemon] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        pokemonAtrapados = obtenerPokemonAtrapados()
        pokemonNoAtrapados = obtenerPokemonNoAtrapados()
    }

    @IBAction func mapTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let remove = pokemonAtrapados[indexPath.row]
            remove.atrapado = false
            pokemonNoAtrapados.append(pokemonAtrapados[indexPath.row])
            pokemonAtrapados.remove(at: indexPath.row)
            do{
                try context.save()
                tableView.reloadData()
            }catch{}
        }
    }}
