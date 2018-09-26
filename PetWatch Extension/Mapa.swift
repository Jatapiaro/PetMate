//
//  InterfaceController.swift
//  PetWatch Extension
//
//  Created by Jacobo Tapia on 25/10/16.
//  Copyright © 2016 Jacobo Tapia. All rights reserved.
//

import WatchKit
import Foundation


class Mapa: WKInterfaceController{
    
    
    
    @IBOutlet var mapa: WKInterfaceMap!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let home = CLLocationCoordinate2D(latitude: 19.2555816, longitude: -99.027023)
        let region=MKCoordinateRegion(center:home, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.mapa.setRegion(region)
        self.mapa.addAnnotation(home, with: .purple)
    }
    
    

    
    
    
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
