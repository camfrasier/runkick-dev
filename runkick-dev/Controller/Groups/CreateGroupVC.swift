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
    let inviteFriendsVC = InviteFriendsVC()
    var delegate: GroupMessageControllerDelegate?
    var inviteDelegate: SendGroupDelegate?
    var inviteFriendsViewExpanded = false
    let blackView = UIView()
    var groupId: String!
    var user: User?
    var groupInstantiated = false
    var groupDateSaved = false
    
    
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
    
    let saveGroupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Group", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 100/255, green: 110/255, blue: 244/255, alpha: 1)
        button.addTarget(self, action: #selector(handleSaveGroup), for: .touchUpInside)
        return button
    } ()

    let inviteFriendsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Invite Friends", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 100/255, green: 110/255, blue: 244/255, alpha: 1)
        button.addTarget(self, action: #selector(presentInviteFriendsVC), for: .touchUpInside)
        return button
    } ()
    
    let privacySettingLabel: UILabel = {
        let label = UILabel()
        label.text = "Set Group to Private"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    } ()
    /*
    let returnHomeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "home_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleReturnHome), for: .touchUpInside)
        return button
    } ()
    */
    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        view.alpha = 1
        return view
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        //view.bindToKeyboard()
        configureViewComponents()
        
        formValidation()
        
        setupToHideKeyboardOnTap()
        
        // calling handleScreenTap from inside our selector
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    let myGroup = DispatchGroup()
        print("this will let me know if the group is set upon dismissal \(groupInstantiated)")
        if groupInstantiated == true {
        
            if groupDateSaved == false {
                
                
                DataService.instance.REF_USER_GROUPS.child(groupId).child("members").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                        
                        
                    for snap in snapshots {
                            
                        let value = snap.value as! String
                            //print("this snap represents one group member uid\(value)")
                            
                        // this should remove the group from the users section if we haven't instantiated the group
                        
                        DataService.instance.REF_USERS.child(value).child("groups").child(self.groupId).removeValue()
                        
                        print("Finished request \(value)")
                            //myGroup.leave()
                        }
                        // waiting for the for loop to complete
                        myGroup.notify(queue: .main) {
                            print("Finished all requests.")
                            
                            DataService.instance.REF_USER_GROUPS.child(self.groupId).removeValue()
                            
                        }
                        
                    }
                    
                })
                
                
                /*
                firstTask { (success) -> Void in
                    if success {
                       // do second task if success
                       // remove group instance
                        
                        print("this should not be before the users are listed")
                       //DataService.instance.REF_USER_GROUPS.child(groupId).removeValue()
                    }
                }
                */


        } else {
            print("view did dissappear called and group saved")
        }
        
        } else {
            print("the group was never instanted")
            // technically the group was instantiated.. but this is hit because the boolean value is reset before leaving the page.
        }
        
        
    }
    
    // completion block function to run and after the group can be removed
    func firstTask(completion: (_ success: Bool) -> Void) {
        
        DataService.instance.REF_USER_GROUPS.child(groupId).child("members").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                
                
            for snap in snapshots {
                    
                let value = snap.value as! String
                    print("this snap represents one group member uid\(value)")
                    
                // this should remove the group from the users section if we haven't instantiated the group
                
                DataService.instance.REF_USERS.child(value).child("groups").child(self.groupId).removeValue()

                }
                
            }
            
        })
            completion(true)
      
        
        
        // Call completion, when finished, success or faliure
        
    }

    

    
    // Creating stackview

    func configureViewComponents() {
        
        //view.addSubview(returnHomeButton)
        //returnHomeButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 60, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 30, height: 30)
        
        view.addSubview(plusPhotoBtn)
        plusPhotoBtn.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
      
        view.addSubview(groupNameTextField)
        groupNameTextField.anchor(top: plusPhotoBtn.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 40)

        view.addSubview(privacySettingLabel)
        privacySettingLabel.anchor(top: groupNameTextField.bottomAnchor, left: groupNameTextField.leftAnchor, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        let switchElement = MainSwitch()
        
        // always set the delegate so that the extention works
        switchElement.delegate = self
        
        
        view.addSubview(switchElement)
        switchElement.anchor(top: privacySettingLabel.topAnchor, left: privacySettingLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: 70, height: 50)
        
        view.addSubview(saveGroupButton)
        saveGroupButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 60, paddingRight: 0, width: 200, height: 50)
        saveGroupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveGroupButton.layer.cornerRadius = 25
        
        view.addSubview(inviteFriendsButton)
        inviteFriendsButton.anchor(top: nil, left: nil, bottom: saveGroupButton.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 60, paddingRight: 0, width: 150, height: 50)
        inviteFriendsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inviteFriendsButton.layer.cornerRadius = 25
        
        
        
        //configureInviteFriendsVC()
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
        guard let groupId = groupId else { return }
        
         print("The saved group id WILL BE DOGG \(groupId)")
        
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
                                            "groupId": groupId,
                                            "profileImageURL": profileImageURL] as [String : Any]
                    
                    //let values = [Auth.auth().currentUser?.uid: dictionaryValues]
                    //let userKey = Auth.auth().currentUser?.uid
                    // Save user info to database
                    
                    
                    /*
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
                    */
                    
                    DataService.instance.REF_USER_GROUPS.child(groupId).updateChildValues(dictionaryValues, withCompletionBlock: { (error, ref) in
                        
                        if self.privacyEnabled == true {
                            DataService.instance.REF_USER_GROUPS.child(groupId).updateChildValues(["privacyEnabled": true, "groupId": groupId])
                            
                        } else {
                            DataService.instance.REF_USER_GROUPS.child(groupId).updateChildValues(["privacyEnabled": false, "groupId": groupId])
                        }
                        
                        // resetting the status which allows us to creat an entire new group
                        self.groupInstantiated = false
                        self.groupDateSaved = true
                        
                        // dissmissing the view
                            _ = self.navigationController?.popViewController(animated: true)
                    })
                  
                }
            })
        }
        
    }
    
    func configureInviteFriendsVC() {
    
           //print("DEBUG: Right menu is configured at this point.")
           
           inviteFriendsVC.delegate = self
        

        if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            
            if let window:UIWindow = applicationDelegate.window {
                
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
                blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleInviteFriendsDismiss)))
             
            
                window.addSubview(blackView)
                blackView.frame = window.frame
                         
                UIView.animate(withDuration: 0.5, animations: {
                    self.blackView.alpha = 0
                })
            }
        }
        
           if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
               
               if let window:UIWindow = applicationDelegate.window {
                   
                window.addSubview(inviteFriendsVC.view)

                inviteFriendsVC.view.frame = CGRect(x: 0, y: view.frame.height + 16, width: view.frame.width, height: 675)
                window.addSubview(indicatorView)
                
                indicatorView.anchor(top: inviteFriendsVC.view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: -16, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 5)
                indicatorView.centerX(inView: inviteFriendsVC.view)
            
               }
           }
       }
    
    @objc func handleInviteFriendsDismiss() {

        let height: CGFloat = 650
        
        if inviteFriendsViewExpanded == true {
            
            if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
            
            if let window:UIWindow = applicationDelegate.window {
                
                print("in practice this works")
                let collectionViewY = window.frame.width - height
                
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                            self.inviteFriendsVC.view.frame = CGRect(x: 0, y: -(collectionViewY) + 650, width: window.frame.width, height: self.inviteFriendsVC.view.frame.height)
            
                        self.inviteFriendsViewExpanded = false
                        print("menu expanded set to false")
                    })
                }
            }
        }

        UIView.animate(withDuration: 0.25) {
        self.blackView.alpha = 0
        }
        
        inviteFriendsVC.handleDissmissKeyboard()
         
    }
    
     @objc func presentInviteFriendsVC() {
        
        let inviteFriendsVC = InviteFriendsVC()

        let nav = self.navigationController
        DispatchQueue.main.async {
            
            self.view.window!.backgroundColor = UIColor.white
            nav?.view.layer.add(CATransition().popFromRight(), forKey: kCATransition)
            nav?.pushViewController(inviteFriendsVC, animated: false)
        }
        
        instantiateGroup()
        /*
         
         if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
             if let window:UIWindow = applicationDelegate.window {

                 let height: CGFloat = 650
                 let collectionViewY = window.frame.height - height
                
                UIView.animate(withDuration: 0.15) {
                    self.blackView.alpha = 1
                }
                 
                 UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                         
                     self.inviteFriendsVC.view.frame = CGRect(x: 0, y: collectionViewY, width: window.frame.width, height: self.inviteFriendsVC.view.frame.height)
                     
                     // add bounce of indicator view
                     self.indicatorView.frame.origin.y = self.inviteFriendsVC.view.frame.origin.y - self.inviteFriendsVC.view.frame.height
                     
                     // remove bounce of indicator view
                     //self.indicatorView.frame.origin.y = self.indicatorView.frame.origin.y - self.rightMenuVC.view.frame.height
                     
                     self.inviteFriendsViewExpanded = true
                                                  
                    }) { (_) in
                        
                        if self.groupInstantiated == false {
                            
                        self.instantiateGroup()
                        }
                }
             }
         }
        */
     }

    func instantiateGroup() {
        
        let creationDate = Int(NSDate().timeIntervalSince1970)
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["creationDate": creationDate,
                      "isAdmin": true,
                      "inviteAccepted": true] as [String : Any]
        
        DataService.instance.REF_USERS.child(currentUid).child("groups").childByAutoId().updateChildValues(values, withCompletionBlock: { (error, ref) in
            
            
            // MAJOR KEY WHENEVER WE ARE PULLING MULTIPLE RUNS OF A DATABASE FUNCTION WE NEED TO USE OBSERVE SINGLE EVENT!!
            
            DataService.instance.REF_USERS.child(currentUid).child("groups").queryLimited(toLast: 1).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                
                // preserving groupId
                let groupIdentifier = snapshot.key
                self.groupId = groupIdentifier
                
                print("The new group id instantiated is \(groupIdentifier)")
                
                //DataService.instance.REF_USER_GROUPS.child(groupIdentifier).updateChildValues(["members": currentUid])
                DataService.instance.REF_USER_GROUPS.child("\(groupIdentifier)/members").childByAutoId().setValue(currentUid)
                
                self.inviteFriendsVC.test(groupIdentifier)
                
                
                self.groupInstantiated = true
                print("this group should be instantied here \(self.groupInstantiated)")
            })
        })
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
        
                saveGroupButton.isEnabled = false
                inviteFriendsButton.isEnabled = false
                saveGroupButton.backgroundColor = UIColor(red: 10/255, green: 204/255, blue: 10/255, alpha: 1)
                inviteFriendsButton.backgroundColor = UIColor(red: 10/255, green: 204/255, blue: 10/255, alpha: 1)
                
                return
        }
        
        saveGroupButton.isEnabled = true
        inviteFriendsButton.isEnabled = true
        saveGroupButton.backgroundColor = UIColor(red: 100/255, green: 110/255, blue: 244/255, alpha: 1)
        inviteFriendsButton.backgroundColor = UIColor(red: 100/255, green: 110/255, blue: 244/255, alpha: 1)
        
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

extension CreateGroupVC: InviteFriendsDelegate {
    func handleInviteFriendsToggle(shouldDismiss: Bool) {
        
        if shouldDismiss {
                let height: CGFloat = 625

                if let applicationDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate? {
                    
                if let window:UIWindow = applicationDelegate.window {

                    let collectionViewY = window.frame.width - height
                        //print("we get this far it should toggle back")
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                            
                            self.inviteFriendsVC.view.frame = CGRect(x: 0, y: -(collectionViewY) + 650, width: window.frame.width, height: self.inviteFriendsVC.view.frame.height)
                                                
                            self.inviteFriendsViewExpanded = false
                    
                            //must first complete using this completions block below
                        }) { (_) in
                            //guard let rightMenuOption = rightMenuOption else { return }
                            //self.handleRightMenuToggle(rightMenuOption: rightMenuOption)
                        }
                    }
                }
            } else {
                print("DEBUG: FROM HERE I CAN GET A RESPONSE")
            }

    }
}

extension UIViewController {
    
    func setupToHideKeyboardOnTap()
    {
        
        print("SCREEN IS TAPPED HERE")
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.toDismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func toDismissKeyboard() {
        print("KEYBOARD IS DISMISSED HERE")
        view.endEditing(true)
    }
}
