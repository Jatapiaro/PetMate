//
//  InterfaceController.swift
//  PetWatch Extension
//
//  Created by Jacobo Tapia on 25/10/16.
//  Copyright © 2016 Jacobo Tapia. All rights reserved.
//

import WatchKit
import WatchConnectivity
import Foundation



class InterfaceController: WKInterfaceController,WCSessionDelegate{

    
    weak var watchSession : WCSession!
    var loged = false
    let appGroupID = "group.petmate"
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    
    
    @IBAction func checarLog() {

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
        if(WCSession.isSupported()){
            watchSession = WCSession.default()
            // Add self as a delegate of the session so we can handle messages
            watchSession!.delegate = self
            watchSession!.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
        
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
  
        let message : String = applicationContext["message"] as! String
        
        print("El mensaje\(message)")
        
        //pushController(withName: "LogedIn", context: message)
        
    }
    


}
