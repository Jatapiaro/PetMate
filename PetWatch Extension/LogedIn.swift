//
//  InterfaceController.swift
//  PetWatch Extension
//
//  Created by Jacobo Tapia on 25/10/16.
//  Copyright © 2016 Jacobo Tapia. All rights reserved.
//

import WatchKit
import Foundation


class LogedIn: WKInterfaceController {
    

    @IBOutlet var table: WKInterfaceTable!
    
    var duenio = ["Pedro","Luis","Daniela","Juana","Karen"]
    var matches = ["Toribio","Mukky","Kratos","Colo","Grace"]
    var d = ["Nos gusta comer pasto","Nos corrieron de la casa","Mi perro mato a un vecino","I like turtles, but i got a dog instead","Me tome una foto con Grace cuando deje a Jacobo"]
    var datosJSON="[ {\"nombre\": \"Pedro\", \"mascota\": Toribio,\"descripcion\": \"Nos gusta comer pasto\"}, {\"nombre\": \"Luis\", \"mascota\": Mukky,\"descripcion\": \"Nos corrieron de la casa\"},{\"nombre\": \"Daniela\", \"mascota\": Kratos,\"descripcion\": \"Mi perro mato a un vecino\"},{\"nombre\": \"Juana\", \"mascota\": Colo,\"descripcion\": \"I like turtles, but i got a dog instead\"},{\"nombre\": \"Karen\", \"mascota\": Grace,\"descripcion\": \"Me tome una foto con Grace cuando deje a Jacobo\"}]"
    var nuevoArray:NSArray?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        tableRefresh()
    }
    
    func JSONParseArray(_ string: String) -> [AnyObject]{
        if let data = string.data(using: String.Encoding.utf8){
            
            do{
                
                if let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [AnyObject] {
                    return array
                }
            }catch{
                
                print("error")
                //handle errors here
                
            }
        }
        return [AnyObject]()
    }
    
    func tableRefresh(){
        table.setNumberOfRows(matches.count, withRowType: "row")
        for indice in 0..<matches.count {
            let elRenglon=table.rowController(at: indice) as! RowController
            elRenglon.name.setText(matches[indice])
            elRenglon.duenio.setText("Dueño: \(duenio[indice])")
            //print(matches[indice])
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        let d=Duenio(n:duenio[rowIndex],m:matches[rowIndex],d:self.d[rowIndex] )
        return d
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
