//
//  ViewController.swift
//  PetMate
//
//  Created by Jacobo Tapia on 17/10/16.
//  Copyright © 2016 Jacobo Tapia. All rights reserved.
//

import UIKit
import MapKit
import AdSupport


class MapController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var map: MKMapView!
    let annotation = MKPointAnnotation()
    var locationManager = CLLocationManager()
    var cityName = String()
    var miniLoc = String()
    var state = String()
    var country = String()
    var checkedLoc = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    
    @IBAction func handleTap(_ sender: AnyObject) {
        map.removeAnnotations(map.annotations)
        let loc = sender.location(in: map)
        let coordinates = self.map.convert(loc,toCoordinateFrom: self.map)
        print("Cordenadas: \(coordinates)")
        
        getInfo(coordinates: coordinates)
        
        annotation.coordinate = coordinates;
        annotation.subtitle = cityName+","+state+","+country
        
        print("My variable: \(cityName)")
        
        map.addAnnotation(annotation)
        map.selectAnnotation(map.annotations[0], animated: true)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManager.startUpdatingLocation()
            //map.showsUserLocation = true
        }else{
            locationManager.stopUpdatingLocation()
            map.showsUserLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if checkedLoc == false{
            let userLoction: CLLocation = locations[0]
            let latitude = userLoction.coordinate.latitude
            let longitude = userLoction.coordinate.longitude
            let latDelta: CLLocationDegrees = 0.05
            let lonDelta: CLLocationDegrees = 0.05
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            
            map.removeAnnotations(map.annotations)
            getInfo(coordinates: location)
            
            
            annotation.coordinate = location;
            annotation.subtitle = cityName+","+state+","+country
            
            //print("My variable: \(cityName)")
            
            
            map.setRegion(region, animated: true)
            map.addAnnotation(annotation)
            map.selectAnnotation(map.annotations[0], animated: true)
            checkedLoc = true
        }
    }
    
    
    func getInfo(coordinates : CLLocationCoordinate2D){
        let geoCoder = CLGeocoder()
        
        let geoLoc = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        geoCoder.reverseGeocodeLocation(geoLoc, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            print("Place \(placeMark)")
            
            // Address dictionary
            print(placeMark.addressDictionary, terminator: "")
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                //print(locationName, terminator: "")
                print("LocName \(locationName)")
            }
            
            //self.miniLoc = placeMark.subAdministrativeArea!
            self.state = placeMark.administrativeArea!
            //self.miniLoc = placeMark.subLocality!
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                print(street, terminator: "")
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                self.annotation.title = city as String
                print(city, terminator: "")
                self.cityName = city as String
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                print(zip, terminator: "")
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                self.country = country as String
                print(country, terminator: "")
            }
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
