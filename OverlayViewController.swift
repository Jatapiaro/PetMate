//
//  OverlayViewController.swift
//  PetMate
//
//  Created by Jacobo Tapia on 21/10/16.
//  Copyright © 2016 Jacobo Tapia. All rights reserved.
//

import UIKit

class OverlayViewController: UIViewController {

    @IBOutlet weak var takePhoto: UIButton!
    
    @IBOutlet weak var guardar: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func capturePhoto(){
        
    }
    
    @IBAction func savePhoto(){
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
