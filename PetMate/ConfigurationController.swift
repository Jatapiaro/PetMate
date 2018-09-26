//
//  ViewController.swift
//  PetMate
//
//  Created by Jacobo Tapia on 17/10/16.
//  Copyright © 2016 Jacobo Tapia. All rights reserved.
//

import UIKit
import Firebase
import Social

class ConfigurationController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var profileImg: UIImageView!
    let miPicker = UIImagePickerController()
    
    var curUsr = User()
    let uid = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        profileImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImg)))
            profileImg.isUserInteractionEnabled = true
        getCurUser()

    }
    
    func handleSelectProfileImg(){
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            miPicker.delegate = self
            miPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(miPicker,animated: true,completion:nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImg.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func subirFotoADB(_ sender: AnyObject) {
        
        
        
        let imageName = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("profile-images").child("\(imageName).jpg")
        
        if let profileImage = self.profileImg.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                    let r=FIRDatabase.database().reference().child("users").child(self.uid!)
                    let values = ["name": self.curUsr.name! as String, "petname": self.curUsr.petname! as String,"email": self.curUsr.email! as String,"profileImage": profileImageUrl as String] as [String : Any]
                    r.updateChildValues(values)
                }
            })
        }
        
        let alertView = UIAlertView(title: "Salvada", message: "En la base de datos", delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    
    func getCurUser(){
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with:
            {snapshot in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.curUsr.setValuesForKeys(dictionary)
                }
                
        })
    }
    

    @IBAction func shareTwitter(_ sender: Any) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        vc?.setInitialText("Hola followers, quiero recomendarles la app PetMate")
        vc?.add(profileImg.image)
        present(vc!,animated:true,completion:nil)
    }
    
    
    
}
