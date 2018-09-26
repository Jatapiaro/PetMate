//
//  ViewController.swift
//  PetMate
//
//  Created by Jacobo Tapia on 20/10/16.
//  Copyright © 2016 Jacobo Tapia. All rights reserved.
//

import UIKit
import Firebase
import WatchKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",style: .plain,target:self,action: #selector(handleLogout))*/
        
        self.navigationItem.hidesBackButton = true
        
        if FIRAuth.auth()?.currentUser?.uid == nil {
            handleLogout()
        }
    }
    
    func handleLogout(){
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "Login")
        self.show(vc as! UIViewController, sender: vc)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    

}

