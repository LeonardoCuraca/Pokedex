//
//  Funciones.swift
//  PokemonGo
//
//  Created by mbtec22 on 6/25/20.
//  Copyright © 2020 mbtec22. All rights reserved.
//
import UIKit
import CoreData

func agregarPokemon() {
    crearPokemon(xnombre: "Mew", ximagenNombre: "mew")
    crearPokemon(xnombre: "Meowth", ximagenNombre: "meowth")
    crearPokemon(xnombre: "Abra", ximagenNombre: "abra")
    crearPokemon(xnombre: "Bullbasaur", ximagenNombre: "bullbasaur")
    crearPokemon(xnombre: "Dratini", ximagenNombre: "dratini")
    crearPokemon(xnombre: "Eevee", ximagenNombre: "eevee")
    crearPokemon(xnombre: "Mankey", ximagenNombre: "mankey")
    crearPokemon(xnombre: "Pikachu", ximagenNombre: "pikachu-2")
    crearPokemon(xnombre: "Psyduck", ximagenNombre: "psyduck")
    crearPokemon(xnombre: "Rattata", ximagenNombre: "rattata")
    crearPokemon(xnombre: "Snorlax", ximagenNombre: "snorlax")
    crearPokemon(xnombre: "Squirtle", ximagenNombre: "squirtle")
    crearPokemon(xnombre: "Venonat", ximagenNombre: "venonat")
    crearPokemon(xnombre: "Weedle", ximagenNombre: "weedle")
    crearPokemon(xnombre: "Zubat", ximagenNombre: "zubat")
    crearPokemon(xnombre: "Jigglypuff", ximagenNombre: "jigglypuff")
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func crearPokemon(xnombre: String, ximagenNombre: String) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let pokemon = Pokemon(context: context)
    pokemon.nombre = xnombre
    pokemon.imagenNombre = ximagenNombre
}

func obtenerPokemon() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
        let pokemon = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        if pokemon.count == 0 {
            agregarPokemon()
            return obtenerPokemon()
        }
        return pokemon
    } catch {}
    return []
}

func obtenerPokemonAtrapados() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let queryConWhere = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    queryConWhere.predicate = NSPredicate(format: "atrapado = true")
    do {
        let pokemon = try context.fetch(queryConWhere) as [Pokemon]
        return pokemon
    } catch {}
    return []
}

func obtenerPokemonNoAtrapados() -> [Pokemon] {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let queryConWhere = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    queryConWhere.predicate = NSPredicate(format: "atrapado = false")
    do {
        let pokemon = try context.fetch(queryConWhere) as [Pokemon]
        return pokemon
    } catch {}
    return []
}
