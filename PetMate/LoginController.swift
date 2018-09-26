//
//  ViewController.swift
//  PetMate
//
//  Created by Jacobo Tapia on 17/10/16.
//  Copyright © 2016 Jacobo Tapia. All rights reserved.
//

import UIKit
import WatchConnectivity
import Firebase

class LoginController: UIViewController,UITextFieldDelegate, WCSessionDelegate {
    
    var watchSession : WCSession?
    var formContainerViewHeightAnchor : NSLayoutConstraint?
    var nameTextFiledHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var petNameTextFieldHeightAnchor: NSLayoutConstraint?
    
    lazy var loginRegister : UISegmentedControl = {
        let lg = UISegmentedControl(items: ["Login","Registrarse"])
        lg.backgroundColor = UIColor(red:160/255,green:247/255,blue:160/255,alpha:1)
        lg.tintColor = UIColor.black
        lg.selectedSegmentIndex = 0
        lg.addTarget(self, action: #selector(handleLoginRegister), for: .valueChanged)
        lg.translatesAutoresizingMaskIntoConstraints = false
        return lg
    }()
    
    let formContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red:160/255,green:247/255,blue:160/255,alpha:1)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font=UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRegisterOrLogin), for: .touchUpInside)
        return button
    }()
    
    let nameTextField: UITextField = {
        let texto = UITextField()
        texto.translatesAutoresizingMaskIntoConstraints = false
        return texto
    }()
    
    let nameSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view;
    }();
    
    let petNameTextField: UITextField = {
        let texto = UITextField()
        texto.translatesAutoresizingMaskIntoConstraints = false
        return texto
    }()
    
    let petNameSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view;
    }();
    
    let emailTextField: UITextField = {
        let texto = UITextField()
        texto.placeholder = "Email"
        texto.text = "jacob.et.cetera@gmail.com"
        texto.keyboardType = UIKeyboardType.emailAddress
        texto.translatesAutoresizingMaskIntoConstraints = false
        return texto
    }()
    
    let emailSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view;
    }();
    
    let passwordTextField: UITextField = {
        let texto = UITextField()
        texto.placeholder = "Password"
        texto.text = "jacobo"
        texto.isSecureTextEntry = true
        texto.translatesAutoresizingMaskIntoConstraints = false
        return texto
    }()
    
    let passwordSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view;
    }();
    
    let petmateImage : UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "petmate")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        view.addSubview(formContainer)
        view.addSubview(registerButton)
        view.addSubview(nameTextField)
        view.addSubview(nameSeparator)
        view.addSubview(emailTextField)
        view.addSubview(passwordSeparator)
        view.addSubview(passwordTextField)
        view.addSubview(emailSeparator)
        view.addSubview(petmateImage)
        view.addSubview(petNameSeparator)
        view.addSubview(petNameTextField)
        view.addSubview(loginRegister)
        setupAllComponents()
        
        /*
         * If this device can support a WatchConnectivity session,
         * obtain a session and activate.
         *
         * It isn't usually recommended to put this in viewDidLoad,
         * we're only doing it here to keep the app simple
         *
         * Note: Even though we won't be receiving messages in the View Controller,
         * we still need to supply a delegate to activate the session
         */
        if(WCSession.isSupported()){
            watchSession = WCSession.default()
            watchSession!.delegate = self
            watchSession!.activate()
        }
        
        
    }
    
    func handleRegisterOrLogin(){

        if loginRegister.selectedSegmentIndex == 0{
            handleLogin()
        }else{
            handleRegister()
        }
    }
    
    func handleLogin(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error)
                return
            }
            
           
            
            if let _ : String = "Usuario logeado" {
                do {
                    try self.watchSession?.updateApplicationContext(
                        ["message" : "Logeado"]
                    )
                } catch let error as NSError {
                    NSLog("Updating the context failed: " + error.localizedDescription)
                }
            }
            
            self.nameTextField.text=""
            self.petNameTextField.text=""
            
            //successfully logged in our user
            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "Main")
            self.show(vc as! UIViewController, sender: vc)
            
        })
    }
    
    func handleRegister(){
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text, let petname=petNameTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            //successfully authenticated user
            let ref = FIRDatabase.database().reference(fromURL: "https://petmate-845e8.firebaseio.com/")
            let usersReference = ref.child("users").child(uid)
            let values = ["name": name, "petname":petname,"email": email,"profileImage": ""]
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil {
                    print(err)
                    return
                }
                
                
                
                if let message : String = FIRAuth.auth()?.currentUser?.uid {
                    do {
                        try self.watchSession?.updateApplicationContext(
                            ["message" : message]
                        )
                    } catch let error as NSError {
                        NSLog("Updating the context failed: " + error.localizedDescription)
                    }
                }
                
                self.nameTextField.text=""
                self.petNameTextField.text=""
                let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "Main")
                self.show(vc as! UIViewController, sender: vc)
                
            })
            
        })
    }
    
    func handleLoginRegister(){
        let label=loginRegister.titleForSegment(at: loginRegister.selectedSegmentIndex)
        registerButton.setTitle(label, for: .normal)
        
        //formContainerViewHeightAnchor?.constant = loginRegister.selectedSegmentIndex == 0 ? 100 : 150
        

        nameTextFiledHeightAnchor?.isActive = false
        petNameTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor?.isActive = false
        
        if loginRegister.selectedSegmentIndex == 0 {
            
            petNameTextField.placeholder = ""
            nameTextField.placeholder = ""
            setupAllComponents()
            
        }else{
            
            petNameTextField.placeholder = "Nombre de tu mascota"
            nameTextField.placeholder = "Tu Nombre"
            
            nameTextFiledHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: formContainer.heightAnchor, multiplier: 1/4)
            petNameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: formContainer.heightAnchor, multiplier: 1/4)
            emailTextFieldHeightAnchor = petNameTextField.heightAnchor.constraint(equalTo: formContainer.heightAnchor, multiplier: 1/4)
            passwordTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: formContainer.heightAnchor, multiplier: 1/4)
            
        }
        
        petNameTextFieldHeightAnchor?.isActive = true
        nameTextFiledHeightAnchor?.isActive = true
        emailTextFieldHeightAnchor?.isActive = true
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    func setupAllComponents(){
        setupFormContainer()
        setupRegisterButton()
        setupNameTextField()
        setupEmailTextField()
        setupPasswordTextField()
        setupImage()
        setupPetNameTextField()
        setupLoginRegister()
    }
    
    func setupLoginRegister(){
        loginRegister.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegister.bottomAnchor.constraint(equalTo: formContainer.topAnchor,constant:-12).isActive = true
        loginRegister.widthAnchor.constraint(equalTo: formContainer.widthAnchor,multiplier: 1/2).isActive = true
        loginRegister.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupImage(){
        petmateImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        petmateImage.bottomAnchor.constraint(equalTo: loginRegister.topAnchor, constant: -12).isActive = true
        petmateImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        petmateImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupPetNameTextField(){
        petNameTextField.leftAnchor.constraint(equalTo: formContainer.leftAnchor, constant: 12).isActive = true
        petNameTextField.widthAnchor.constraint(equalTo: formContainer.widthAnchor).isActive = true
        petNameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        petNameTextFieldHeightAnchor=petNameTextField.heightAnchor.constraint(equalTo: formContainer.heightAnchor, multiplier: 0)
        petNameTextFieldHeightAnchor?.isActive = true
        petNameTextField.delegate = self
        //emailTextField.resignFirstResponder()
        
        petNameSeparator.leftAnchor.constraint(equalTo: formContainer.leftAnchor).isActive = true
        petNameSeparator.widthAnchor.constraint(equalTo: formContainer.widthAnchor).isActive = true
        petNameSeparator.topAnchor.constraint(equalTo: petNameTextField.bottomAnchor).isActive = true
        petNameSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
    func setupEmailTextField(){
        emailTextField.leftAnchor.constraint(equalTo: formContainer.leftAnchor, constant: 12).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: formContainer.widthAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: petNameTextField.bottomAnchor).isActive = true
        emailTextFieldHeightAnchor=emailTextField.heightAnchor.constraint(equalTo: formContainer.heightAnchor, multiplier:1/2)
        emailTextFieldHeightAnchor?.isActive = true
        emailTextField.delegate = self
        //emailTextField.resignFirstResponder()
        
        emailSeparator.leftAnchor.constraint(equalTo: formContainer.leftAnchor).isActive = true
        emailSeparator.widthAnchor.constraint(equalTo: formContainer.widthAnchor).isActive = true
        emailSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupPasswordTextField(){
        passwordTextField.leftAnchor.constraint(equalTo: formContainer.leftAnchor, constant: 12).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: formContainer.widthAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextFieldHeightAnchor=passwordTextField.heightAnchor.constraint(equalTo: formContainer.heightAnchor, multiplier:1/2)
        passwordTextFieldHeightAnchor?.isActive = true
        passwordTextField.delegate = self
        
        passwordSeparator.leftAnchor.constraint(equalTo: formContainer.leftAnchor).isActive = true
        passwordSeparator.widthAnchor.constraint(equalTo: formContainer.widthAnchor).isActive = true
        passwordSeparator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
    
    func setupNameTextField(){
        
        nameTextField.leftAnchor.constraint(equalTo: formContainer.leftAnchor, constant: 12).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: formContainer.widthAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: formContainer.topAnchor).isActive = true
        nameTextFiledHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: formContainer.heightAnchor, multiplier: 0)
        nameTextFiledHeightAnchor?.isActive = true
        nameTextField.delegate=self
        
        nameSeparator.leftAnchor.constraint(equalTo: formContainer.leftAnchor).isActive = true
        nameSeparator.widthAnchor.constraint(equalTo: formContainer.widthAnchor).isActive = true
        nameSeparator.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    
    func setupRegisterButton(){
        /*
         *Constraints for button
         */
        registerButton.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: formContainer.bottomAnchor,constant:12).isActive = true
        registerButton.widthAnchor.constraint(equalTo: formContainer.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    
    func setupFormContainer(){
        /*
         *Constraints for form
         */
        formContainer.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive=true
        formContainer.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive=true
        formContainer.widthAnchor.constraint(equalTo: view.widthAnchor,constant:-24).isActive=true
        formContainerViewHeightAnchor=formContainer.heightAnchor.constraint(equalToConstant: 100)
        formContainerViewHeightAnchor?.isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        view.endEditing(true)
        textField.resignFirstResponder()
        return true;
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    

    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    
    
}
