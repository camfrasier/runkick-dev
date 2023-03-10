//
//  EditProfileController.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/31/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

class EditProfileController: UIViewController {
    
    // MARK: - Properties
    
    var user: User?
    var imageChanged = false
    var usernameChanged = false
    var firstnameChanged = false
    var lastnameChanged = false
    var userProfileController: UserProfileVC?
    var updatedUsername: String?
    var updatedFirstname: String?
    var updatedLastname: String?

    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.borderStyle = .none
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    
    let firstnameTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.borderStyle = .none
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        //tf.isUserInteractionEnabled = false // we are making this not editable
        return tf
    }()
    
    let lastnameTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.borderStyle = .none
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        //tf.isUserInteractionEnabled = false // we are making this not editable
        return tf
    }()
    
    let firstnameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let lastnameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let firstnameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let lastnameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let usernameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        //extends the edges beyound the tab bar
        edgesForExtendedLayout = .all
        extendedLayoutIncludesOpaqueBars = true
        */
        
        configureNavigationBar()
        
        configureViewComponents()
        
        usernameTextField.delegate = self
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
        
        loadUserData()
    }
    
    
    // MARK: - Handlers
    
    @objc func handleChangeProfilePhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSaved() {
        
        view.endEditing(true)
        
        // we wamt to add a prompt here that says data saved!
        
        if usernameChanged {
            updateUsername()
        }
        
        if firstnameChanged {
            updateFirstname()
        }
        
        if lastnameChanged {
            updateLastname()
        }
        
        if imageChanged {
            print("AFTER SAVING IF THE IMAGE HAS CHANGE THIS VALUE IS TRUE \(imageChanged as Bool?)")
            updateProfileImage()
        }
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func loadUserData() {
        guard let user = self.user else { return }
        
        guard let profileImageUrl = user.profileImageURL else { return }
        
        profileImageView.loadImage(with: profileImageUrl)
        firstnameTextField.text = user.firstname
        lastnameTextField.text = user.lastname
        usernameTextField.text = user.username
    }
    
    func configureViewComponents() {
        
        view.backgroundColor = .white
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 150)
        let containerView = UIView(frame: frame)
        containerView.backgroundColor = UIColor.groupTableViewBackground
        view.addSubview(containerView)
        
        containerView.addSubview(profileImageView)
        profileImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 16, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        //profileImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        profileImageView.layer.cornerRadius = 80 / 2
        
        containerView.addSubview(changePhotoButton)
        changePhotoButton.anchor(top: profileImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        changePhotoButton.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        
        containerView.addSubview(separatorView)
        separatorView.anchor(top: nil, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        view.addSubview(firstnameLabel)
        firstnameLabel.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(lastnameLabel)
        lastnameLabel.anchor(top: firstnameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: lastnameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(firstnameTextField)
        firstnameTextField.anchor(top: containerView.bottomAnchor, left: firstnameLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 18, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: (view.frame.width / 1.6), height: 0)
        
        view.addSubview(lastnameTextField)
        lastnameTextField.anchor(top: firstnameTextField.bottomAnchor, left: lastnameLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 18, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: (view.frame.width / 1.6), height: 0)
        
        view.addSubview(usernameTextField)
        usernameTextField.anchor(top: lastnameTextField.bottomAnchor, left: usernameLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 18, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: (view.frame.width / 1.6), height: 0)
        
        view.addSubview(firstnameSeparatorView)
        firstnameSeparatorView.anchor(top: nil, left: firstnameTextField.leftAnchor, bottom: firstnameTextField.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -8, paddingRight: 12, width: 0, height: 0.5)
        
        view.addSubview(lastnameSeparatorView)
        lastnameSeparatorView.anchor(top: nil, left: lastnameTextField.leftAnchor, bottom: lastnameTextField.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -8, paddingRight: 12, width: 0, height: 0.5)
        
        view.addSubview(usernameSeparatorView)
        usernameSeparatorView.anchor(top: nil, left: usernameTextField.leftAnchor, bottom: usernameTextField.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -8, paddingRight: 12, width: 0, height: 0.5)
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)]
        
        let font = UIFont(name: "HelveticaNeue-Bold", size: 17)!
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)]
        navigationItem.title = "Edit Profile"
        
        navigationController?.navigationBar.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSaved))
        
        
        // custom back button
             
         let returnNavButton = UIButton(type: UIButton.ButtonType.custom)
         
         returnNavButton.frame = CGRect(x: 0, y: 0, width: 33, height: 33)
         
         //using this code to show the true image without rendering color
         returnNavButton.setImage(UIImage(named:"whiteCircleLeftArrowTB")?.withRenderingMode(.alwaysOriginal), for: .normal)
         returnNavButton.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 33, height: 33 )
        returnNavButton.addTarget(self, action: #selector(EditProfileController.handleBackButton), for: .touchUpInside)
         returnNavButton.tintColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
         returnNavButton.backgroundColor = .clear
             
         let notificationBarBackButton = UIBarButtonItem(customView: returnNavButton)
         self.navigationItem.leftBarButtonItems = [notificationBarBackButton]
    }
    
    @objc func handleBackButton() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - API
    
    func updateUsername() {
        
        guard let updatedUsername = self.updatedUsername else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard usernameChanged == true else { return }
        
        print("This IS THE USERNAME STRING \(updatedUsername)")
        
        DataService.instance.REF_USERS.child(currentUid).child("username").setValue(updatedUsername) { (err, ref) in
            
            guard let userProfileController = self.userProfileController else { return }
            userProfileController.fetchCurrentUserData()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    func updateFirstname() {
        
        guard let updatedFirstname = self.updatedFirstname else { return }
        guard firstnameChanged == true else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
    
        print("This IS THE FIRSTNAME STRING \(updatedFirstname)")

        DataService.instance.REF_USERS.child(currentUid).child("firstname").setValue(updatedFirstname) { (err, ref) in
            
            guard let userProfileController = self.userProfileController else { return }
            userProfileController.fetchCurrentUserData()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func updateLastname() {
        
        guard let updatedLastname = self.updatedLastname else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard lastnameChanged == true else { return }
        
        
        DataService.instance.REF_USERS.child(currentUid).child("lastname").setValue(updatedLastname) { (err, ref) in
            
            guard let userProfileController = self.userProfileController else { return }
            userProfileController.fetchCurrentUserData()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func updateProfileImage() {
 
        print("HERE WE UPDATE PROFILE IMAGE")
        guard imageChanged == true else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }    // Auth.auth singleton
        guard let user = self.user else { return }
        
        
        DataService.instance.REF_USERS.child(currentUid).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild("profileImageURL") {
                
                DataService.instance.REF_USERS.child(currentUid).child("profileImageURL").observe(.value) { (snapshot) in
                let url = snapshot.value as! String
                
                    if url != "" {
                        
                        print("THE URL VALUE IS NOT EMPTY SO WE SHOULD ERASE")
                        
                        // here we need to check for images that already exist.. and also we need to ensure if one does exist it is deleted accordingly
                        Storage.storage().reference(forURL: user.profileImageURL).delete(completion: nil)
        
                    }
                }
                         let filename = NSUUID().uuidString
                         
                        guard let updatedProfileImage = self.profileImageView.image else { return }
                         
                         guard let imageData = updatedProfileImage.jpegData(compressionQuality: 1) else { return }
                         
                         let storageRef = DataService.instance.REF_STORAGE_PROFILE_IMAGES.child(filename)
                         
                         storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                             if let error = error {
                                 print("Failed to upload image to storage with error: ", error.localizedDescription)
                             }
                             
                             storageRef.downloadURL(completion: { (url, error) in
                                 if error != nil {
                                     print("Failed to download url:", error!)
                                     return
                                 } else {
                                     let updatedProfileImageURL = (url?.absoluteString)!
                                     print(updatedProfileImageURL)

                                     DataService.instance.REF_USERS.child(currentUid).child("profileImageURL").setValue(updatedProfileImageURL, withCompletionBlock: { (err, ref) in
                                 
                                         guard let userProfileController = self.userProfileController else { return }
                                         userProfileController.fetchCurrentUserData()
                                 
                                         self.dismiss(animated: true, completion: nil)
                                     })
                                 }
                             })
                         }
            } else {
                // create an entirely new post
                print("User photo never existed therefore we need to create a entirely new one")
                //self.handleUploadPost()
                
                
                 let filename = NSUUID().uuidString
                 
                guard let updatedProfileImage = self.profileImageView.image else { return }
                 
                 guard let imageData = updatedProfileImage.jpegData(compressionQuality: 1) else { return }
                 
                 let storageRef = DataService.instance.REF_STORAGE_PROFILE_IMAGES.child(filename)
                 
                 storageRef.putData(imageData, metadata: nil) { (metadata, error) in
                     if let error = error {
                         print("Failed to upload image to storage with error: ", error.localizedDescription)
                     }
                     
                     storageRef.downloadURL(completion: { (url, error) in
                         if error != nil {
                             print("Failed to download url:", error!)
                             return
                         } else {
                             let updatedProfileImageURL = (url?.absoluteString)!
                             print(updatedProfileImageURL)

                             DataService.instance.REF_USERS.child(currentUid).child("profileImageURL").setValue(updatedProfileImageURL, withCompletionBlock: { (err, ref) in
                         
                                 guard let userProfileController = self.userProfileController else { return }
                                 userProfileController.fetchCurrentUserData()
                         
                                 self.dismiss(animated: true, completion: nil)
                             })
                         }
                     })
                 }
            }
        }
    }
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = selectedImage
            self.imageChanged = true
        }
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
        guard let user = self.user else { return }
        
        let firstnameString = firstnameTextField.text?.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        let lastnameString = lastnameTextField.text?.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        let usernameString = usernameTextField.text?.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        
        if user.firstname == firstnameString {
            
            firstnameChanged = false
        }
        
        if user.lastname == lastnameString {
            
            lastnameChanged = false
        }
        
        if user.username == usernameString {
            
            usernameChanged = false
        }
        
        /*
        guard user.firstname != trimmedString else {
            print("ERROR: You did not change you username")
            firstnameChanged = false
            return
        }
        
        guard trimmedString != "" else {
            print("ERROR: Please enter a valid username")
            firstnameChanged = false
            return
        }
        */
        
        updatedFirstname = firstnameString
        firstnameChanged = true
        
        updatedLastname = lastnameString
        lastnameChanged = true
        
        updatedUsername = usernameString?.lowercased()
        usernameChanged = true
        
        /*
        guard let user = self.user else { return }
        
        let trimmedString = usernameTextField.text?.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        
        guard user.username != trimmedString else {
            print("ERROR: You did not change you username")
            usernameChanged = false
            return
        }
        
        guard trimmedString != "" else {
            print("ERROR: Please enter a valid username")
            usernameChanged = false
            return
        }

        updatedUsername = trimmedString?.lowercased()
        usernameChanged = true
        */
    }
    
    @objc func formValidation () {
        guard
            firstnameTextField.hasText,
        lastnameTextField.hasText,
           usernameTextField.hasText == true else {
                
            navigationItem.rightBarButtonItem?.isEnabled = false
            navigationController?.navigationBar.tintColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
            
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            DataService.instance.REF_USERS.child(currentUid).updateChildValues(["profileCompleted": false])
            
            return
        }
        
        navigationItem.rightBarButtonItem?.isEnabled = true
        navigationController?.navigationBar.tintColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        DataService.instance.REF_USERS.child(currentUid).updateChildValues(["profileCompleted": true])
    }
    
    
    
}
