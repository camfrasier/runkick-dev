//
//  EditAdminProfileController.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 10/28/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

class EditAdminProfileController: UIViewController {
    
    // MARK: - Properties
    
    var user: User?
    var imageChanged = false
    var usernameChanged = false
    var adminProfileController: AdminProfileVC?
    var updatedUsername: String?
    
    
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
        return tf
    }()
    
    let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.borderStyle = .none
        tf.isUserInteractionEnabled = false // we are making this not editable
        return tf
    }()
    
    let lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.textAlignment = .left
        tf.borderStyle = .none
        tf.isUserInteractionEnabled = false // we are making this not editable
        return tf
    }()
    
    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let lastNameLabel: UILabel = {
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
    
    let firstNameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let lastNameSeparatorView: UIView = {
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
        
        configureNavigationBar()
        
        configureViewComponents()
        
        usernameTextField.delegate = self
        
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
    
    @objc func handleDone() {
        
        view.endEditing(true)
        
        if usernameChanged {
            updateUsername()
        }
        
        if imageChanged {
            updateProfileImage()
        }
    }
    
    func loadUserData() {
        guard let user = self.user else { return }
        
        profileImageView.loadImage(with: user.profileImageURL)
        firstNameTextField.text = user.firstname
        lastNameTextField.text = user.lastname
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
        
        view.addSubview(firstNameLabel)
        firstNameLabel.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(lastNameLabel)
        lastNameLabel.anchor(top: firstNameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: lastNameLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(firstNameTextField)
        firstNameTextField.anchor(top: containerView.bottomAnchor, left: firstNameLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 18, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: (view.frame.width / 1.6), height: 0)
        
        view.addSubview(lastNameTextField)
        lastNameTextField.anchor(top: firstNameTextField.bottomAnchor, left: lastNameLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 18, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: (view.frame.width / 1.6), height: 0)
        
        view.addSubview(usernameTextField)
        usernameTextField.anchor(top: lastNameTextField.bottomAnchor, left: usernameLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 18, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: (view.frame.width / 1.6), height: 0)
        
        view.addSubview(firstNameSeparatorView)
        firstNameSeparatorView.anchor(top: nil, left: firstNameTextField.leftAnchor, bottom: firstNameTextField.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -8, paddingRight: 12, width: 0, height: 0.5)
        
        view.addSubview(lastNameSeparatorView)
        lastNameSeparatorView.anchor(top: nil, left: lastNameTextField.leftAnchor, bottom: lastNameTextField.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -8, paddingRight: 12, width: 0, height: 0.5)
        
        view.addSubview(usernameSeparatorView)
        usernameSeparatorView.anchor(top: nil, left: usernameTextField.leftAnchor, bottom: usernameTextField.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: -8, paddingRight: 12, width: 0, height: 0.5)
    }
    
    func configureNavigationBar() {
        
        navigationItem.title = "Edit Profile"
        
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDone))
    }
    
    // MARK: - API
    
    func updateUsername() {
        
        guard let updatedUsername = self.updatedUsername else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard usernameChanged == true else { return }
        
        DataService.instance.REF_USERS.child(currentUid).child("username").setValue(updatedUsername) { (err, ref) in
            
            guard let adminProfileController = self.adminProfileController else { return }
            adminProfileController.fetchCurrentUserData()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func updateProfileImage() {
        
        guard imageChanged == true else { return }
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = self.user else { return }
        
        
        Storage.storage().reference(forURL: user.profileImageURL).delete(completion: nil)
        
        let filename = NSUUID().uuidString
        
        guard let updatedProfileImage = profileImageView.image else { return }
        
        //guard let imageData = updatedProfileImage.jpegData(compressionQuality: 0.3) else { return }
        guard let imageData = updatedProfileImage.jpegData(compressionQuality: 0.2) else { return }
        
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
                        
                        guard let adminProfileController = self.adminProfileController else { return }
                        adminProfileController.fetchCurrentUserData()
                        
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            })
        }
    }
}

extension EditAdminProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = selectedImage
            self.imageChanged = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension EditAdminProfileController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
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
    }
}

