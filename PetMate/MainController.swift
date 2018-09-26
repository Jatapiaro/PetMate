//
//  ViewController.swift
//  PetMate
//
//  Created by Jacobo Tapia on 17/10/16.
//  Copyright © 2016 Jacobo Tapia. All rights reserved.
//

import UIKit
import Firebase
///Hla
class MainController: UIViewController{

    @IBOutlet weak var logout: UIButton!
    @IBOutlet weak var nav: UINavigationBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logout.setTitle("Logout", for: .normal)
        logout.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
    }
    

    func handleLogout(){
        do{
            try FIRAuth.auth()?.signOut()
        }catch let logoutError{
            print(logoutError)
        }
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "Login")
        self.show(vc as! UIViewController, sender: vc)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tableView(_ sender: AnyObject) {
        let chatL = ChatListController()
        let navController = UINavigationController(rootViewController: chatL)
        present(navController,animated: true,completion: nil)
    }
    
    
    
}
