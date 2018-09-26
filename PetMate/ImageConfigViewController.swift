//
//  ImageConfigViewController.swift
//  PetMate
//
//  Created by Karla on 27/10/16.
//  Copyright © 2016 Jacobo Tapia. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
class ImageConfigViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UNUserNotificationCenterDelegate {

    
    @IBOutlet weak var profImg1: UIImageView!
    @IBOutlet weak var profImg2: UIImageView!
    @IBOutlet weak var profImg3: UIImageView!
    @IBOutlet weak var profImg4: UIImageView!
    @IBOutlet weak var profImg5: UIImageView!
    @IBOutlet weak var profImg6: UIImageView!
    
    let imgPicker = UIImagePickerController()
    let imgPicker2 = UIImagePickerController()
    let imgPicker3 = UIImagePickerController()
    let imgPicker4 = UIImagePickerController()
    let imgPicker5 = UIImagePickerController()
    let imgPicker6 = UIImagePickerController()
    
    var countPicked = 0
    
    var curUsr = User()
    let uid = FIRAuth.auth()?.currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        profImg1.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(selectImg1)))
        profImg1.isUserInteractionEnabled = true
        profImg2.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(selectImg2)))
        profImg2.isUserInteractionEnabled = true
        profImg3.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(selectImg3)))
        profImg3.isUserInteractionEnabled = true
        profImg4.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(selectImg4)))
        profImg4.isUserInteractionEnabled = true
        profImg5.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(selectImg5)))
        profImg5.isUserInteractionEnabled = true
        profImg6.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(selectImg6)))
        profImg6.isUserInteractionEnabled = true
        
        getCurUser()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    func selectImg1(){
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            countPicked = 1
            imgPicker.delegate = self
            imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imgPicker,animated:true,completion:nil)
        }
    }
    func selectImg2(){
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            countPicked = 2
            imgPicker2.delegate = self
            imgPicker2.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imgPicker2,animated:true,completion:nil)
        }
    }
    func selectImg3(){
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            countPicked = 3
            imgPicker3.delegate = self
            imgPicker3.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imgPicker3,animated:true,completion:nil)
        }
    }
    func selectImg4(){
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            countPicked = 4
            imgPicker4.delegate = self
            imgPicker4.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imgPicker4,animated:true,completion:nil)
        }
    }
    func selectImg5(){
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            countPicked = 5
            imgPicker5.delegate = self
            imgPicker5.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imgPicker5,animated:true,completion:nil)
        }
    }
    func selectImg6(){
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            countPicked = 6
            imgPicker6.delegate = self
            imgPicker6.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(imgPicker6,animated:true,completion:nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var pickedImage : UIImage?
        
        if let editImg = info["UIImagePickerControllerEditedImage"] as? UIImage {
            pickedImage = editImg
        }else if let originImg = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            pickedImage = originImg
        }
        
        if countPicked == 1{
            profImg1.image = pickedImage
        }else if countPicked == 2{
            profImg2.image = pickedImage
        }else if countPicked == 3{
            profImg3.image = pickedImage
        }else if  countPicked == 4 {
            profImg4.image = pickedImage
        }else if countPicked == 5 {
            profImg5.image = pickedImage
        }else{
            profImg6.image = pickedImage
        }
        
        
        dismiss(animated: true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true,completion: nil)
    }
    
    
    @IBAction func subirDB(_ sender: AnyObject) {
        let imgName = UUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("config-images").child("\(imgName).jpg")
        
        /*if let configImage = self.profImg1.image, let uploadData = UIImageJPEGRepresentation(configImage, 0.1) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                if let ConfigImageUrl = metadata?.downloadURL()?.absoluteString {
                    let r=FIRDatabase.database().reference().child("users").child(self.uid!)
                    let values = ["name": self.curUsr.name! as String, "petname": self.curUsr.petname! as String,"email": self.curUsr.email! as String,"profileImage": profileImageUrl as String, "configImage": ConfigImageUrl as String] as [String : Any]
                    r.updateChildValues(values)
                }
            })
        }
        if let configImage = self.profImg2.image, let uploadData = UIImageJPEGRepresentation(configImage, 0.1) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                if let ConfigImageUrl = metadata?.downloadURL()?.absoluteString {
                    let r=FIRDatabase.database().reference().child("users").child(self.uid!)
                    let values = ["name": self.curUsr.name! as String, "petname": self.curUsr.petname! as String,"email": self.curUsr.email! as String,"profileImage": profileImageUrl as String, "configImage": ConfigImageUrl as String] as [String : Any]
                    r.updateChildValues(values)
                }
            })
        }
        
        if let configImage = self.profImg3.image, let uploadData = UIImageJPEGRepresentation(configImage, 0.1) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                if let ConfigImageUrl = metadata?.downloadURL()?.absoluteString {
                    let r=FIRDatabase.database().reference().child("users").child(self.uid!)
                    let values = ["name": self.curUsr.name! as String, "petname": self.curUsr.petname! as String,"email": self.curUsr.email! as String,"profileImage": profileImageUrl as String, "configImage": ConfigImageUrl as String] as [String : Any]
                    r.updateChildValues(values)
                }
            })
        }
        
        if let configImage = self.profImg4.image, let uploadData = UIImageJPEGRepresentation(configImage, 0.1) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                if let ConfigImageUrl = metadata?.downloadURL()?.absoluteString {
                    let r=FIRDatabase.database().reference().child("users").child(self.uid!)
                    let values = ["name": self.curUsr.name! as String, "petname": self.curUsr.petname! as String,"email": self.curUsr.email! as String,"profileImage": profileImageUrl as String, "configImage": ConfigImageUrl as String] as [String : Any]
                    r.updateChildValues(values)
                }
            })
        }
        if let configImage = self.profImg5.image, let uploadData = UIImageJPEGRepresentation(configImage, 0.1) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                if let ConfigImageUrl = metadata?.downloadURL()?.absoluteString {
                    let r=FIRDatabase.database().reference().child("users").child(self.uid!)
                    let values = ["name": self.curUsr.name! as String, "petname": self.curUsr.petname! as String,"email": self.curUsr.email! as String,"profileImage": profileImageUrl as String, "configImage": ConfigImageUrl as String] as [String : Any]
                    r.updateChildValues(values)
                }
            })
        }
        
        if let configImage = self.profImg6.image, let uploadData = UIImageJPEGRepresentation(configImage, 0.1) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                if let ConfigImageUrl = metadata?.downloadURL()?.absoluteString {
                    let r=FIRDatabase.database().reference().child("users").child(self.uid!)
                    let values = ["name": self.curUsr.name! as String, "petname": self.curUsr.petname! as String,"email": self.curUsr.email! as String,"profileImage": profileImageUrl as String, "configImage": ConfigImageUrl as String] as [String : Any]
                    r.updateChildValues(values)
                }
            })
        }
        
        let alertView = UIAlertView(title: "Salvada", message: "En la base de datos", delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
        */
    }
    
    func getCurUser(){
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with:
            {snapshot in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.curUsr.setValuesForKeys(dictionary)
                }
                
        })
    }
    
    @IBAction func NotificationPush() {
        let content = UNMutableNotificationContent()
        content.title = "Recordatorio"
        content.subtitle = "Petmate te invita"
        content.body = "Recuerda checar tus matches"
        content.badge = 1
        content.categoryIdentifier = "notCategoryActions"
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5.0, repeats: false)
        
        let requestIdentifier = "Recordatorio"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            error in
        })
    }
}
extension ViewController: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        
    }
}

