//
//  AdminLoginVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 10/27/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase


// may not need this page later 

/*
protocol AdminLoginVCDelegate {
    func storeUserVariable(value: Bool)
}
 */
//var emailPlaceholder = String ()

//var adminVariable: Bool?
//var adminDelegate: AdminLoginVCDelegate?

class AdminLoginVC: UIViewController, UITextFieldDelegate, Alertable {
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Email"
        tf.backgroundColor = UIColor(red: 250/255, green: 170/255, blue: 120/255, alpha: 1)
        //tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 19)
        tf.layer.cornerRadius = 5
        tf.textColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    } ()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Admin Password"
        //tf.backgroundColor = UIColor(white: 0, alpha: 0.25)
        tf.backgroundColor = UIColor(red: 250/255, green: 170/255, blue: 120/255, alpha: 1)
        //tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 19)
        tf.layer.cornerRadius = 5
        tf.textColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    } ()
    
    
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .clear
        //iv.image = #imageLiteral(resourceName: "waywalkLogoBlack")
        iv.image = UIImage(named: "peachyGreensLogoWhite")
        iv.tintColor = UIColor(red: 9/255, green: 171/255, blue: 231/255, alpha: 1)
        return iv
    } ()
    
    let adminLoginMessage: UILabel = {
        let label = UILabel()
        label.text = "Please login as an administrator below."
        label.font = UIFont(name: "Avenir Next", size: 14)
        //label.font = UIFont(name: "Arial Rounded MT Bold", size: 45)
        //label.textColor = UIColor(red: 9/255, green: 171/255, blue: 231/255, alpha: 1)
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    let userLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 20)
        button.backgroundColor = UIColor(red: 250/255, green: 170/255, blue: 120/255, alpha: 1)
        button.addTarget(self, action: #selector(handleSaveProfile), for: .touchUpInside)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let cancelLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.setTitleColor(.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the delegate of the email field to be this ViewController.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // binds view to keyboard to lift as the keyboard expands
        view.bindToKeyboard()
        
        // calling handleScreenTap from inside our selector
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
        
        configureViewComponents()
    }
    
    func configureViewComponents() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        
        view.backgroundColor = UIColor(red: 250/255, green: 150/255, blue: 90/255, alpha: 1)
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 320, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 110)
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 218, paddingLeft: 95, paddingBottom: 0, paddingRight: 0, width: 220, height: 90)
        
        view.addSubview(cancelLoginButton)
        cancelLoginButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(adminLoginMessage)
        adminLoginMessage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 295, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        
        view.addSubview(userLoginButton)
        userLoginButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 30, paddingRight: 40, width: 0, height: 50)
    }
    
    @objc func formValidation () {
        guard
            emailTextField.hasText,
            passwordTextField.hasText == true else {
                
                userLoginButton.isEnabled = false
                userLoginButton.backgroundColor = UIColor(red: 250/255, green: 170/255, blue: 120/255, alpha: 1)
                
                return
        }
        
        userLoginButton.isEnabled = true
        //userLoginButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        userLoginButton.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        userLoginButton.setTitleColor(UIColor(red: 250/255, green: 150/255, blue: 90/255, alpha: 1), for: .normal)
    }
    
    @objc func handleScreenTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    /*
    @objc func handleUserVariable(value: Bool) {
        delegate?.storeUserVariable(value: value)
    }
    */
    
    @objc func handleCancelButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func handleSaveProfile() {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    if let user = user {
                        let userData = ["provider": user.user.providerID, "isStoreadmin": true] as [String: Any]
                        DataService.instance.createFirebaseDBUser(uid: user.user.uid, userData: userData, isStoreadmin: true)
                    }
                    print("Email user authenticated successfully with Firebase")
                    self.dismiss(animated: true, completion: nil)
                    
                } else {
                    if let errorCode = AuthErrorCode(rawValue: error!._code) {
                        switch errorCode {
                        case .wrongPassword:
                            self.showAlert("Whoops.. user entered incorrect password!")
                        default:
                            self.showAlert("Unexpected error.. please try again.")
                        }
                    }
                }
            })
        }
    }
}
