//
//  SignUpVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/15/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase



//var userEmail = emailPlaceholder
var userEmail: String?
var imageSelected = false

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Alertable {
    
    let plusPhotoBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        //button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        return button
    } ()
    
    let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "First Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    } ()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    } ()
    
    let lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    } ()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.autocapitalizationType = .none
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    } ()
    
    let saveProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Profile", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        //button.addTarget(self, action: #selector(handleSaveProfile), for: .touchUpInside)
        return button
    } ()
    
    let registerProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save!", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.addTarget(self, action: #selector(handleRegisterProfile), for: .touchUpInside)
        return button
    } ()
    
    let returnHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "home_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleReturnHome), for: .touchUpInside)
        return button
    } ()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = userEmail
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            emailLabel.text = Auth.auth().currentUser?.email
            userEmail = emailLabel.text
            
        } else if Auth.auth().currentUser == nil {
            userEmail = ""
        }
        
        view.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 250)
        
        view.addSubview(plusPhotoBtn)
        plusPhotoBtn.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        configureViewComponents()
        
        view.addSubview(returnHomeButton)
        returnHomeButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 60, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
        
        view.addSubview(emailLabel)
        emailLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 210, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 40, height: 40)
    }
    
    // Creating stackview

    func configureViewComponents() {
        
        let stackView = UIStackView(arrangedSubviews: [firstNameTextField, lastNameTextField, usernameTextField, emailTextField, passwordTextField, registerProfileButton])
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: plusPhotoBtn.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 240)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // select image.
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            imageSelected = false
            return
        }
        // set imageSelected to true
        print("Image selected!")
        imageSelected = true
    
        //configure plusPhotoBtn with selected image.
        plusPhotoBtn.layer.cornerRadius = plusPhotoBtn.frame.width / 2
        plusPhotoBtn.layer.masksToBounds = true
        plusPhotoBtn.layer.borderColor = UIColor.black.cgColor
        plusPhotoBtn.layer.borderWidth = 2
        plusPhotoBtn.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func handleReturnHome() {
        //_ = navigationController?.popViewController(animated: true)
        
        guard let navController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController else { return }
        guard let controller = navController.viewControllers[0] as? MainTabVC else { return }
        controller.configureViewControllers()
        print("handle cancel is pressed with delay and reset")
        
        
        self.dismiss(animated:true, completion: nil)
    }
    
    
    @objc func handleRegisterProfile() {
    
          guard
              let email = emailTextField.text,
            let firstName = firstNameTextField.text,
            let lastName =  lastNameTextField.text,
            let username = usernameTextField.text,
              let password = passwordTextField.text else { return }
        
        
          
          Auth.auth().fetchSignInMethods(forEmail: email, completion: ({ (providers, error) in
              print("here are the providers \(providers as Any)")
              
              if providers == nil {
                  
                  Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                      if error == nil {
                          // create a new user account.. and suggest user finish updating profile basics
             
                          if let user = user {

                              let userData = ["provider": user.user.providerID,"email": email, "firstname": firstName, "lastname": lastName, "username": username, "profileCompleted": false, "isStoreadmin": false] as [String: Any]
                            
                              
                              DataService.instance.createFirebaseDBUser(uid: user.user.uid, userData: userData, isStoreadmin: false)
                              

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

    
    /*
    @objc func handleSaveProfile() {
        
        print("HERE WE SHOULD SAVE THE PROFILE")
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName =  lastNameTextField.text else { return }
        guard let email =  emailTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for user in userSnapshot {
                    if user.key == Auth.auth().currentUser?.uid {
                        DataService.instance.REF_USERS.child(user.key).updateChildValues(["email": email as Any, "firstname": firstName, "lastname": lastName, "username": username])
                    }
                }
            }
        })
        
        // Set the profile image.
        guard let profileImg = self.plusPhotoBtn.imageView?.image else { return }
        
        // Upload data.
        guard let uploadData = profileImg.jpegData(compressionQuality: 0.3) else { return }
        
        // Place image in Firebase storeage
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child(filename)
        storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
            
        // Profile image url.
        storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print("Failed to download url:", error!)
                    return
                } else {
                    let profileImageURL = (url?.absoluteString)!
                    print(profileImageURL)
                    
                    guard let fcmToken = Messaging.messaging().fcmToken else { return }
                    
                    let dictionaryValues = ["firstname": firstName,
                                            "lastname": lastName,
                                            "email": email,
                                            "fcmToken": fcmToken, // automatically upload in database right away
                                            "username": username,
                                            "profileImageURL": profileImageURL]
                    //let values = [Auth.auth().currentUser?.uid: dictionaryValues]
                    let userKey = Auth.auth().currentUser?.uid
                    // Save user info to database
                    DataService.instance.REF_USERS.child(userKey!).updateChildValues(dictionaryValues, withCompletionBlock: { (error, ref) in
                        print("Successfully created user and saved information to database.")
                        DataService.instance.REF_USERS.child(userKey!).updateChildValues(["profileCompleted": true])
                        
                        // Set a global variable that will allow me to compare weather or not it was set. This way it goes directly to the user profile when done.
                        self.dismiss(animated:true, completion: nil)
                    })
                }
            })
        }
        
    }
    */
    
    @objc func handleSelectProfilePhoto () {
        
        // configure image picker.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    
    }
    
    @objc func formValidation () {
        guard
            //imageSelected,
            firstNameTextField.hasText,
            lastNameTextField.hasText,
            emailTextField.hasText,
            usernameTextField.hasText == true else {
        
                registerProfileButton.isEnabled = false
                registerProfileButton.backgroundColor = UIColor(red: 250/255, green: 150/255, blue: 90/255, alpha: 1)
                
                return
        }
        
        registerProfileButton.isEnabled = true
        registerProfileButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
}



