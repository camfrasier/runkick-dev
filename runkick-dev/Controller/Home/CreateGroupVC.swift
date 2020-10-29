//
//  CreateGroupVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 10/19/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

protocol GroupMessageControllerDelegate {
    func handleInviteFriendsToggle(shouldDismiss: Bool)
}

class CreateGroupVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, Alertable {
    
    var userGroup: UserGroup?
    var didSelectImage = false
    var groupImageSelected = false
    var privacyEnabled = false
    var delegate: GroupMessageControllerDelegate?
    
    let plusPhotoBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        return button
    } ()
    
    let groupNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Group Name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 22)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    } ()
    
    let saveProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Group", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 100/255, green: 110/255, blue: 244/255, alpha: 1)
        button.addTarget(self, action: #selector(handleSaveGroup), for: .touchUpInside)
        return button
    } ()
    
    let privacySettingLabel: UILabel = {
        let label = UILabel()
        label.text = "Set Group to Private"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    } ()
    
    let returnHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "home_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleReturnHome), for: .touchUpInside)
        return button
    } ()


    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        view.bindToKeyboard()
        configureViewComponents()
        
        formValidation()
        
        // calling handleScreenTap from inside our selector
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    // Creating stackview

    func configureViewComponents() {
        
        view.addSubview(returnHomeButton)
        returnHomeButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 30, height: 30)
        
        view.addSubview(plusPhotoBtn)
        plusPhotoBtn.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 120, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
        view.addSubview(groupNameTextField)
        groupNameTextField.anchor(top: plusPhotoBtn.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 40)

        view.addSubview(privacySettingLabel)
        privacySettingLabel.anchor(top: groupNameTextField.bottomAnchor, left: groupNameTextField.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let switchElement = MainSwitch()
        
        // always set the delegate so that the extention works
        switchElement.delegate = self
        
        
        view.addSubview(switchElement)
        switchElement.anchor(top: privacySettingLabel.topAnchor, left: privacySettingLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: 70, height: 50)
        
        view.addSubview(saveProfileButton)
        saveProfileButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 60, paddingRight: 0, width: 200, height: 60)
        saveProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveProfileButton.layer.cornerRadius = 25
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // select image.
        guard let profileImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            groupImageSelected = false
            return
        }
        
        // set imageSelected to true
        print("Image selected!")
        groupImageSelected = true
    
        //configure plusPhotoBtn with selected image.
        plusPhotoBtn.layer.cornerRadius = plusPhotoBtn.frame.width / 2
        plusPhotoBtn.layer.masksToBounds = true
        plusPhotoBtn.layer.borderColor = UIColor.black.cgColor
        plusPhotoBtn.layer.borderWidth = 2
        plusPhotoBtn.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)

    }

    
    @objc func handleScreenTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    
    @objc func handleSaveGroup() {
        
        print("HERE WE SHOULD SAVE THE Group PROFILE")
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let groupName = groupNameTextField.text else { return }
        
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        // Set the group profile image.
        guard let profileImg = self.plusPhotoBtn.imageView?.image else { return }
        
        // Upload data.
        guard let uploadData = profileImg.jpegData(compressionQuality: 0.3) else { return }
        
        // Place image in Firebase storeage
        let filename = NSUUID().uuidString
        //let storageRef = Storage.storage().reference().child("group_profile_images").child(filename)
        let storageRef = DataService.instance.REF_STORAGE_GROUP_PROFILE_IMAGES.child(filename)
        
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
                    
                    let dictionaryValues = ["creationDate": creationDate,
                                            "groupName": groupName,
                                            "groupOwnerId": currentUid,
                                            "fcmToken": fcmToken, // automatically upload in database right away
                                            "profileImageURL": profileImageURL] as [String : Any]
                    
                    //let values = [Auth.auth().currentUser?.uid: dictionaryValues]
                    //let userKey = Auth.auth().currentUser?.uid
                    // Save user info to database
                    
                    DataService.instance.REF_USER_GROUPS.childByAutoId().updateChildValues(dictionaryValues, withCompletionBlock: { (error, ref) in
                        print("Successfully created user GROUP and saved information to database.")
                        
                        DataService.instance.REF_USER_GROUPS.queryLimited(toLast: 1).observe(.childAdded) {(snapshot: DataSnapshot) in
                            let groupId = snapshot.key
                            
                            print("The group Id is \(groupId)")
                            
                            if self.privacyEnabled == true {
                                DataService.instance.REF_USER_GROUPS.child(groupId).updateChildValues(["privacyEnabled": true, "groupId": groupId])
                                
                            } else {
                                DataService.instance.REF_USER_GROUPS.child(groupId).updateChildValues(["privacyEnabled": false, "groupId": groupId])
                            }
                            
                        }
                        
                        //DataService.instance.REF_USERS.child(userKey!).updateChildValues(["profileCompleted": true])
                        // Set a global variable that will allow me to compare weather or not it was set. This way it goes directly to the user profile when done.
                        
                        
                        //self.dismiss(animated:true, completion: nil)
      
                        _ = self.navigationController?.popViewController(animated: true)

                    })
  
                }
            })
        }
        
    }
    
    @objc func handleReturnHome() {

        self.dismiss(animated:true, completion: nil)
    }
    
    @objc func handleSelectProfilePhoto() {
        
        // configure image picker.
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    
    }
    
    @objc func formValidation() {
        guard
            groupImageSelected,
            groupNameTextField.hasText == true else {
        
                saveProfileButton.isEnabled = false
                saveProfileButton.backgroundColor = UIColor(red: 10/255, green: 204/255, blue: 10/255, alpha: 1)
                
                
                return
        }
        
        saveProfileButton.isEnabled = true
        saveProfileButton.backgroundColor = UIColor(red: 100/255, green: 110/255, blue: 244/255, alpha: 1)
        
    }
}



extension CreateGroupVC: PrivacyStatusControllerDelegate {
    
    func handlePrivacySetting(privacyToggled: Bool) {
        
        
        if privacyToggled == true {
            
            privacyEnabled = privacyToggled
            print("The privacy value is \(privacyEnabled)")
                    
        }
        
    }
}

