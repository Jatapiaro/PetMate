//
//  DetalleControlador.swift
//  ListasAW
//
//  Created by molina on 22/10/15.
//  Copyright © 2015 Tec de Monterrey. All rights reserved.
//

import WatchKit
import Foundation


class DetalleControlador: WKInterfaceController {
    
    @IBOutlet var descripcion: WKInterfaceLabel!
    @IBOutlet var mascota: WKInterfaceLabel!
    @IBOutlet var nombre: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        let s=context as! Duenio
        let n = s.nombre
        let m = s.mascota
        let d = s.descripcion
        
        nombre.setText(n)
        mascota.setText(m)
        descripcion.setText(d)
        /*let numAgencias=s.agencias
        let contenidoMarca=s.marca
        agencias.setText(String(numAgencias))
        marca.setText(contenidoMarca)*/
        
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
