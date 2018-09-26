//
//  ViewController.swift
//  PetMate
//
//  Created by Jacobo Tapia on 20/10/16.
//  Copyright © 2016 Jacobo Tapia. All rights reserved.
//

import UIKit
import Firebase
import CoreMotion

class Acelerometro: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    let miPicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImg)))
        imageView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view, typically from a nib.
        if motionManager.isDeviceMotionAvailable{
            motionManager.gyroUpdateInterval = 0.1
            motionManager.deviceMotionUpdateInterval = 0.1
            
            motionManager.startDeviceMotionUpdates(to: queue, withHandler: {
                (motion, error) -> Void in
                let userAcc = motion!.gravity

                let rotation = atan2(userAcc.x, userAcc.y) - M_PI
                
                
                DispatchQueue.main.async(execute: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
                })
                
                
                
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            imageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func handleSelectProfileImg(){
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            miPicker.delegate = self
            miPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(miPicker,animated: true,completion:nil)
        }
    }
    

    
}

