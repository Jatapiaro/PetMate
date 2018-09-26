//
//  ViewController.swift
//  PetMate
//
//  Created by Jacobo Tapia on 17/10/16.
//  Copyright © 2016 Jacobo Tapia. All rights reserved.
//

import UIKit

class AugmentedRealityController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    let overlay = OverlayViewController(nibName: "OverlayViewController",bundle: nil)
    let miPicker = UIImagePickerController()
    
    
    
    var image = UIImage()
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            miPicker.delegate = self
            miPicker.sourceType = UIImagePickerControllerSourceType.camera
            miPicker.showsCameraControls = true
            miPicker.cameraOverlayView = overlay.view
            self.present(miPicker,animated: true,completion:nil)
        }
        
        
    }
    

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        
        print("Foto seleccionada");
        
        miPicker.showsCameraControls = false
        
        
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        
        
        
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        //Save camera image
        //UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
        
        

        let alertView = UIAlertView(title: "Salvada", message: "En la App", delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "Configuration")
        self.show(vc as! UIViewController, sender: vc)
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "Configuration")
        self.show(vc as! UIViewController, sender: vc)
        picker.dismiss(animated: true, completion: nil)
    }
    
    

    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
}
