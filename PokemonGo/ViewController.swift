//
//  ViewController.swift
//  PokemonGo
//
//  Created by mbtec22 on 6/25/20.
//  Copyright © 2020 mbtec22. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var ubicacion = CLLocationManager()
    var contActualizaciones = 0
    var pokemon:[Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ubicacion.delegate = self
        pokemon = obtenerPokemon()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            setup()
        } else {
            ubicacion.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            setup()
        }
    }
    
    func setup() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        ubicacion.startUpdatingLocation()
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: {
            (timer) in if let coord = self.ubicacion.location?.coordinate {
                let poke = self.pokemon[Int(arc4random_uniform(UInt32(self.pokemon.count)))]
                let pin = PokePin(coord: coord, pokemon: poke)
                let randomLat = (Double(arc4random_uniform(200)) - 100.0) / 5000.0
                let randomLon = (Double(arc4random_uniform(200)) - 100.0) / 5000.0
                pin.coordinate.longitude += randomLon
                pin.coordinate.latitude += randomLat
                self.mapView.addAnnotation(pin)
            }
            
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (contActualizaciones < 1) {
            let region = MKCoordinateRegionMakeWithDistance(ubicacion.location!.coordinate, 1000, 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        } else {
            ubicacion.stopUpdatingLocation()
        }
    }
    @IBAction func centrarTapped(_ sender: Any) {
        if let coord = ubicacion.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pinView.image = UIImage(named: "player")
            
            var frame = pinView.frame
            frame.size.height = 50
            frame.size.width = 50
            pinView.frame = frame
            
            return pinView
        }
        
        let pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        let pokemon = (annotation as! PokePin).pokemon
    
        pinView.image = UIImage(named: pokemon.imagenNombre!)
        
        var frame = pinView.frame
        frame.size.height = 50
        frame.size.width = 50
        pinView.frame = frame
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        if view.annotation is MKUserLocation {
            return
        }
        let region = MKCoordinateRegionMakeWithDistance(view.annotation!.coordinate, 200, 200)
        mapView.setRegion(region, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            let pokemon = (view.annotation as! PokePin).pokemon
            if let coord = self.ubicacion.location?.coordinate {
                if MKMapRectContainsPoint(mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    if (pokemon.atrapado) {
                        let alertVC = UIAlertController(title: "Pokemon ya encontrado!", message: "¿Deseas volver a capturar a  \(pokemon.nombre!) 🤗?", preferredStyle: .alert)
                        let yesAction = UIAlertAction(title: "Si", style: .default, handler:nil)
                        alertVC.addAction(yesAction)
                        let noAction = UIAlertAction(title: "No", style: .default, handler: {
                            (action) in
                            return
                        })
                        alertVC.addAction(noAction)
                        self.present(alertVC, animated: true, completion: nil)
                    }
                    pokemon.atrapado = true
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    mapView.removeAnnotation(view.annotation!)
                    
                    let alertaVC = UIAlertController(title: "Felicidades!", message: "Atrapaste un \(pokemon.nombre!)", preferredStyle: .alert)
                    let pokedexAccion = UIAlertAction(title: "Pokedex", style: .default, handler: {
                        (action) in
                        self.performSegue(withIdentifier: "pokedexSegue", sender: nil)
                    })
                    alertaVC.addAction(pokedexAccion)
                    let okAccion = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertaVC.addAction(okAccion)
                    self.present(alertaVC, animated: true, completion: nil)
                } else {
                    let alertaVC = UIAlertController(title: "Ups!", message: "Estás muy lejos de ese \(pokemon.nombre!)", preferredStyle: .alert)
                    let okAccion = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertaVC.addAction(okAccion)
                    self.present(alertaVC, animated: true, completion: nil)
                }
            }
        })
    }
}


