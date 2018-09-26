//
//  Duenio.swift
//  PetMate
//
//  Created by Jacobo Tapia on 28/11/16.
//  Copyright © 2016 Jacobo Tapia. All rights reserved.
//

import WatchKit

class Duenio: NSObject {
    var nombre:String
    var mascota:String
    var descripcion:String
    
    init(n:String, m:String, d:String)
    {
        nombre=n
        mascota = m
        descripcion = d
    }
    
}
