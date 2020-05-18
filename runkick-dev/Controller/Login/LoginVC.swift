//
//  LoginVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/6/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

var user: String?
//var leftSidePanelVC: LeftSidePanelVC?

class LoginVC: UIViewController, UITextFieldDelegate, Alertable {
    
    var homeVC: HomeVC?
    var delegate: AdminLoginControllerDelegate?
    var storeAdminStatus: Bool?
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "  Email"
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
        tf.placeholder = "  Password"
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
        iv.image = UIImage(named: "poppwalkSweat")
        iv.tintColor = UIColor(red: 9/255, green: 171/255, blue: 231/255, alpha: 1)
        return iv
    } ()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Already a user? Login below.."
        label.font = UIFont(name: "Avenir Next", size: 14)
        label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    } ()
    
    lazy var userSignUpLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Quick sign up here!"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1)
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleUserSignIn))
        followTap.numberOfTapsRequired = 1
        label.addGestureRecognizer(followTap)
        return label
    } ()
    
    let userLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 20)
        button.backgroundColor = UIColor(red: 250/255, green: 170/255, blue: 120/255, alpha: 1)
        button.addTarget(self, action: #selector(handleUserLogin), for: .touchUpInside)
        button.layer.cornerRadius = 25
        return button
    } ()
    
    let cancelLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel Login", for: .normal)
        button.setTitleColor(.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        return button
    } ()
    
    
    let adminLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "Admin Login"
        label.font = UIFont(name: "Avenir Next", size: 14)
        label.textColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    } ()
    
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

    // self.homeVC?.dismissLoginView()
    
    func configureViewComponents() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        //let titleStackView = UIStackView(arrangedSubviews: [loginTitleLabel1, loginTitleLabel2])
        
        
        view.backgroundColor = UIColor.rgb(red: 181, green: 201, blue: 215)
        
        
        let switchElement = MainSwitch()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        /*
        titleStackView.axis = .horizontal
        titleStackView.distribution = .fillEqually
        titleStackView.alignment = .firstBaseline
        */
        
        //view.addSubview(switchElement)
       //switchElement.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 70, height: 50)
        
        //view.addSubview(adminLoginLabel)
        //adminLoginLabel.anchor(top: view.topAnchor, left: nil, bottom: nil, right: switchElement.leftAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 320, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 110)
        
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 218, paddingLeft: 95, paddingBottom: 0, paddingRight: 0, width: 220, height: 90)
        
        view.addSubview(loginLabel)
        loginLabel.anchor(top: nil, left: view.leftAnchor, bottom: stackView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 8, paddingRight: 40, width: 0, height: 0)
        
        //view.addSubview(userSignUpLabel)
        //userSignUpLabel.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 140, paddingBottom: 0, paddingRight: 40, width: 0, height: 0)
        
        view.addSubview(cancelLoginButton)
        cancelLoginButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

        view.addSubview(userLoginButton)
        userLoginButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 40, paddingBottom: 30, paddingRight: 40, width: 0, height: 50)
    }
    
    @objc func formValidation () {
        guard
            emailTextField.hasText,
            passwordTextField.hasText == true else {
                
                userLoginButton.isEnabled = false
                userSignUpLabel.isEnabled = false
                
                userLoginButton.backgroundColor = UIColor(red: 250/255, green: 170/255, blue: 120/255, alpha: 1)
                userSignUpLabel.textColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
                return
        }
        
        userLoginButton.isEnabled = true
        //userLoginButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
        userLoginButton.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        userLoginButton.setTitleColor(UIColor(red: 250/255, green: 150/255, blue: 90/255, alpha: 1), for: .normal)

        
        userSignUpLabel.isEnabled = true
        userSignUpLabel.isUserInteractionEnabled = true
        userSignUpLabel.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }
    
    @objc func handleScreenTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func handleCancelButton() {
        
        //this function is important because it allows the root navigation controller to REBOOT and login again
        
        guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
        guard let controller = navController.viewControllers[0] as? MainTabVC else { return }
        controller.configureViewControllers()
        print("handle cancel is pressed with delay and reset")
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAdminLogin() {
        
        self.dismiss(animated:true, completion: nil)
        
        delegate?.handleAdminLogin(shouldDismiss: true)
        
        //let adminLoginVC = AdminLoginVC()
        //present(adminLoginVC, animated: true, completion:nil)
    }
    
    @objc func handleUserSignIn() {
  
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        Auth.auth().fetchSignInMethods(forEmail: email, completion: ({ (providers, error) in
            print("here are the providers \(providers as Any)")
            
            if providers == nil {
                
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil {
                        // create a new user account.. and suggest user finish updating profile basics
           
                        if let user = user {

                            let userData = ["provider": user.user.providerID, "email": email, "username": email, "profileCompleted": false, "isStoreadmin": false] as [String: Any]
                            
                            DataService.instance.createFirebaseDBUser(uid: user.user.uid, userData: userData, isStoreadmin: false)
                            
                            //leftSidePanelVC?.fetchCurrentUserData()
                            
                            
                            //this function is important because it allows the root navigation controller to REBOOT and login again
                            guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                            guard let controller = navController.viewControllers[0] as? MainTabVC else { return }
                            controller.configureViewControllers()
                            
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                        
                    }  else {
                        if let errorCode = AuthErrorCode(rawValue: error!._code) {
                            switch errorCode {
                            case .invalidEmail:
                                self.showAlert("That is an invalid email! Please try again")
                            default: break
                            }
                        }
                    }
                })
    
            } else {
                
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error == nil {
                        print("User authenticated successfully with Firebase.")
                        
                        guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                        guard let controller = navController.viewControllers[0] as? MainTabVC else { return }
                        controller.configureViewControllers()
                         
                        self.dismiss(animated: true, completion: nil)
                        //leftSidePanelVC?.fetchCurrentUserData()
                        
                        // hopefully this reloads the tableview data
                        self.homeVC?.configureMenuView()  //will try to fetch data if this doesn't work on view did appear.
                        
                    } else {
                        
                        if let errorCode = AuthErrorCode(rawValue: error!._code) {
                            switch errorCode {
                            case .wrongPassword:
                                self.showAlert("Whoops! That was the wrong password!")
                            case .invalidEmail:
                                self.showAlert("That is an invalid email! Please try again")
                            default:
                                self.showAlert("Have you signed up for an account?")
                            }
                        }
                    }
                })
            }
        }))
        
    }

    @objc func handleUserLogin() {
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                // check if user exists already..
                
                Auth.auth().fetchSignInMethods(forEmail: email, completion: ({ (providers, error) in
                    print("here are the providers \(providers as Any)")
                    
                    if providers == nil {
                        print("user does not have an account set up")
                        
                        // maybe use some sort of email verification method here..
                        
                        guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                        guard let controller = navController.viewControllers[0] as? MainTabVC else { return }
                        controller.configureViewControllers()
                        
                        self.dismiss(animated:true, completion: nil)
                        
                    } else {
                        
                        print("User authenticated successfully with Firebase.")
                        self.dismiss(animated: true, completion: nil)
                        
                        // hopefully this reloads the tableview data
                        guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                        guard let controller = navController.viewControllers[0] as? MainTabVC else { return }
                        controller.configureViewControllers()

                    }
                }))
                
            } else {
                
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    switch errorCode {
                    case .wrongPassword:
                        self.showAlert("Whoops! That was the wrong password!")
                    case .invalidEmail:
                        self.showAlert("That is an invalid email! Please try again")
                    default:
                        self.showAlert("Have you signed up for an account?")
                    }
                }
            }
        })
    }
    

    
    // may not need this function.. will manually mark admin status for now
    func handleAdminProfile() {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    
                    if let user = user {
                        let userData = ["provider": user.user.providerID] as [String: Any]
                        DataService.instance.verifyFirebaseAdmin(uid: user.user.uid, userData: userData)
                    }
                    print("DEBUG: Email user authenticated successfully with Firebaseas ADMIN")
                    
                    guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
                    guard let controller = navController.viewControllers[0] as? MainTabVC else { return }
                    controller.configureViewControllers()
                    
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

/*
// may not need this function at the end of the day
extension LoginVC: AdminStatusControllerDelegate {
    func handleLoginStatus(adminToggled: Bool) {
        
        if adminToggled == true {
            storeAdminStatus = true
            print("DEBUG: Store admin status is TRUUUEEEEEEEE")
        }
    }
}
*/
        





