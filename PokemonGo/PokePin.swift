//
//  PokePin.swift
//  PokemonGo
//
//  Created by mbtec22 on 7/2/20.
//  Copyright © 2020 mbtec22. All rights reserved.
//

import UIKit
import MapKit

class PokePin : NSObject, MKAnnotation {
    var coordinate : CLLocationCoordinate2D
    var pokemon : Pokemon
    init (coord: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}
