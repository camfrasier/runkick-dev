//
//  UploadStorePostVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 5/2/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

// MARK: - Init

class UploadStorePostVC: UIViewController, UITextFieldDelegate {
    
    
    // MARK: - Properties
    
    // enumeration that helps with changing the share button value depending on whether we are uploading or editing
    enum UploadAction: Int {
        case UploadPost
        case SaveChanges
        
        // initialize enum with uploadpost action
        init(index: Int) {
            switch index {
            case 0: self = .UploadPost
            case 1: self = .SaveChanges
            default: self = .UploadPost
            }
        }
    }
    
    var uploadAction: UploadAction!
    var selectedImage: UIImage?
    var postToEdit: StorePost?
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    } ()
    
    let captionTextView: UITextField = {
        let tv = UITextField()
        tv.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        tv.placeholder = "  Item caption here.."
        tv.textColor = UIColor.darkGray
        tv.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tv.font = UIFont.systemFont(ofSize: 18)
        return tv
    } ()
    
    let descriptionTextView: UITextField = {
        let tv = UITextField()
        tv.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        tv.textColor = UIColor.darkGray
        tv.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    } ()
    
    let storeTitleTextView: UITextField = {
        let tv = UITextField()
        tv.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        tv.textColor = UIColor.darkGray
        tv.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    } ()
    
    let storeIdTextView: UITextField = {
        let tv = UITextField()
        tv.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        tv.textColor = UIColor.darkGray
        tv.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    } ()
    
    let categoryTextView: UITextField = {
        let tv = UITextField()
        tv.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        tv.textColor = UIColor.darkGray
        tv.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    } ()
    
    let priceTextView: UITextField = {
        let tv = UITextField()
        tv.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        tv.textColor = UIColor.darkGray
        tv.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    } ()
    
    let poppPriceTextView: UITextField = {
        let tv = UITextField()
        tv.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        tv.textColor = UIColor.darkGray
        tv.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    } ()
    
    let pointsTextView: UITextField = {
        let tv = UITextField()
        tv.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        tv.textColor = UIColor.darkGray
        tv.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    } ()
    
    let caloriesTextView: UITextField = {
        let tv = UITextField()
        tv.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        tv.textColor = UIColor.darkGray
        tv.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        tv.font = UIFont.systemFont(ofSize: 15)
        return tv
    } ()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        return label
    } ()
    
    let storeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Store Name"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        return label
    } ()
    
    let storeIdLabel: UILabel = {
        let label = UILabel()
        label.text = "Store ID"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        return label
    } ()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        return label
    } ()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        return label
    } ()
    
    let caloriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Calories"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        return label
    } ()
    
    let poppPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "PoppPrice"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        return label
    } ()
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.text = "Points Required"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        return label
    } ()
    
    let locationDistanceLabel: UILabel = {
        let label = UILabel()
        label.text = "5.5mi"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        return label
    } ()


    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleUploadAction), for: .touchUpInside)
        button.isEnabled = false // Disable the button until we have a caption.
        return button
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure view components.
        configureViewComponents()
        
        // Load the image.
        loadImage()
        
        captionTextView.delegate = self // Just telling our program that this view controller will be the delegate for handling all the data.
        storeTitleTextView.delegate = self
        storeIdTextView.delegate = self
        categoryTextView.delegate = self
        priceTextView.delegate = self
        descriptionTextView.delegate = self
        poppPriceTextView.delegate = self
        pointsTextView.delegate = self
        caloriesTextView.delegate = self
        
        view.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 250)
    }
    
    // using view will appear because view did load actually only calls once, which is not the case in view did appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if uploadAction == .SaveChanges {
            guard let post = self.postToEdit else { return }
            actionButton.setTitle("Save Changes", for: .normal)
            self.navigationItem.title = "Edit Post"
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
            navigationController?.navigationBar.tintColor = .black
            

            
            photoImageView.loadImage(with: post.imageUrl)
            captionTextView.text = post.caption
            storeTitleTextView.text = post.title
            storeIdTextView.text = post.storeId
            descriptionTextView.text = post.description
            categoryTextView.text = post.category
            priceTextView.text = String(post.price)
            poppPriceTextView.text = String(post.poppPrice)
            pointsTextView.text = String(post.points)
            caloriesTextView.text = String(post.calories)
            
            
            
            //priceTextView.text = String(post.price)
            //poppPriceTextView.text = String(post.poppPrice)
            
        } else {
            actionButton.setTitle("Share", for: .normal)
            self.navigationItem.title = "Upload Post"
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
            navigationController?.navigationBar.tintColor = .black
        }
    }
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func configureViewComponents() {
        
        // Note that 92 is the correct padding needed from the top of the Nav menu.
        view.addSubview(photoImageView)
        photoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: view.topAnchor, left: photoImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 100)
        
        view.addSubview(storeTitleLabel)
        storeTitleLabel.anchor(top: captionTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(storeTitleTextView)
        storeTitleTextView.anchor(top: captionTextView.bottomAnchor, left: storeTitleLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 30)
        
        view.addSubview(storeIdLabel)
        storeIdLabel.anchor(top: storeTitleTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(storeIdTextView)
        storeIdTextView.anchor(top: storeTitleTextView.bottomAnchor, left: storeIdLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 30)
        
        view.addSubview(categoryLabel)
        categoryLabel.anchor(top: storeIdTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(categoryTextView)
        categoryTextView.anchor(top: storeIdTextView.bottomAnchor, left: categoryLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 30)
        
        view.addSubview(priceLabel)
        priceLabel.anchor(top: categoryTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(priceTextView)
        priceTextView.anchor(top: categoryTextView.bottomAnchor, left: priceLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 30)
        
        view.addSubview(poppPriceLabel)
        poppPriceLabel.anchor(top: priceTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(poppPriceTextView)
        poppPriceTextView.anchor(top: priceTextView.bottomAnchor, left: poppPriceLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 30)
        
        
        view.addSubview(pointsLabel)
        pointsLabel.anchor(top: poppPriceTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(pointsTextView)
        pointsTextView.anchor(top: poppPriceTextView.bottomAnchor, left: pointsLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 30)
        
        view.addSubview(caloriesLabel)
        caloriesLabel.anchor(top: pointsTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(caloriesTextView)
        caloriesTextView.anchor(top: pointsTextView.bottomAnchor, left: caloriesLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 30)
        
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: caloriesTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(descriptionTextView)
        descriptionTextView.anchor(top: caloriesTextView.bottomAnchor, left: descriptionLabel.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 60)
        
        view.addSubview(actionButton)
        actionButton.anchor(top: descriptionTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 40)
    }
    
    func loadImage() {
    
        guard let selectedImage = self.selectedImage else { return }
        
        photoImageView.image = selectedImage
        
    }
    
    @objc func handleUploadAction() {
        
        buttonSelector(uploadAction: uploadAction)
    }
    
    func buttonSelector(uploadAction: UploadAction) {
        
        switch uploadAction {
            
        case .UploadPost:
            handleUploadPost()
            
        case .SaveChanges:
            handleSavePostChanges()
        }
    }
    
    /*
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    */
    
    
    func handleUploadPost() {
        
        // Parameters
        guard
            let caption = captionTextView.text,
            let postImg = photoImageView.image,
            let storeTitle = storeTitleTextView.text,
            let storeId = storeIdTextView.text,
            //let price = Int(priceTextView.text),
            //let poppPrice = Int(poppPriceTextView.text),
            let price = Double(priceTextView.text ?? ""),
            let poppPrice = Double(poppPriceTextView.text ?? ""),
            let points = Int(pointsTextView.text ?? ""),
            let calories = Int(caloriesTextView.text ?? ""),
            let description = descriptionTextView.text,
            let category = categoryTextView.text,
            let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // Get image upload data.
        //guard let uploadData = postImg.jpegData(compressionQuality: 0.3) else { return }
        guard let uploadData = postImg.jpegData(compressionQuality: 1) else { return }
        
        // Update storage
        let filename = NSUUID().uuidString
        let creationDate = Int(NSDate().timeIntervalSince1970)
        
        // creating a new folder for admin_store_images
        let storageRef = Storage.storage().reference().child("admin_store_images").child(filename)
        //let storageRef = Storage.storage().reference().child("profile_images").child(filename)
        
        storageRef.putData(uploadData, metadata: nil) {(metadata, error) in
            
            if let error = error {
                print("Failed to upload image to storage with error", error.localizedDescription)
                return
            }
            
            // Image URL.
            
            storageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print("Failed to download url:", error!)
                    return
                } else {
                    let postImageUrl = (url?.absoluteString)!
                    print(postImageUrl)
                    
                    let values = ["caption": caption,
                                  "creationDate": creationDate,
                                  "title": storeTitle,
                                  "storeId": storeId,
                                  "category": category,
                                  "price": price,
                                  "points": points,
                                  "poppPrice": poppPrice,  // here i need to upload as an int
                                    "calories": calories,
                                    "description": description,
                                  "imageUrl": postImageUrl,
                                  "ownerUid": currentUid] as [String: Any]
                    
                    
                    /*
                    // Post id.
                    let postId = DataService.instance.REF_POSTS.childByAutoId()
                    let userPostId = DataService.instance.REF_USER_POSTS
                    */
                    
                    // store post id for generic admin store post feed
                    let postId = DataService.instance.REF_ADMIN_STORE_POSTS.childByAutoId()
                    let adminPostId = DataService.instance.REF_ADMIN_USER_POSTS
                    
                    // Upload information to database.
                    
                    postId.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        
                        guard let postKey = postId.key else { return }
                        // update user post section.
                        adminPostId.child(currentUid).updateChildValues([postKey: 1])
                        
                        // return to home feed. MAY NEED TO TEST TO MAKE SURE THIS DISMISSES CORRECTLY
                        self.dismiss(animated: true, completion: {
                            self.tabBarController?.selectedIndex = 1
                        })
                        
                        //self.dismiss(animated: true, completion: nil)
                    })
                }
            })
        }
    }
    
    /*
    // Use this if you have a UITextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // make sure the result is under 16 characters
        return updatedText.count <= 120
    }
    */
    
    func handleSavePostChanges() {
        guard let post = self.postToEdit else { return }
        let updatedCaption = captionTextView.text
        let updatedDescription = descriptionTextView.text
        let updatedStoreTitle = storeTitleTextView.text
        let updatedStoreId = storeIdTextView.text
        let updatedCategory = categoryTextView.text
        let updatedPrice = priceTextView.text
        let updatedPoppPrice = poppPriceTextView.text
        let updatedPointsRequired = pointsTextView.text
        let updatedCalories = caloriesTextView.text
        
        //uploadHastagToServer(withPostId: post.postId)
        

        DataService.instance.REF_ADMIN_STORE_POSTS.child(post.postId).child("caption").setValue(updatedCaption) { (err, ref) in
            
            // using the dismiss here instead of pop because we are in a naviagation view and it's smoother going back this way
            self.dismiss(animated: true, completion: nil)
        }
        
        DataService.instance.REF_ADMIN_STORE_POSTS.child(post.postId).child("description").setValue(updatedDescription) { (err, ref) in
            
            // using the dismiss here instead of pop because we are in a naviagation view and it's smoother going back this way
            self.dismiss(animated: true, completion: nil)
        }
        
        DataService.instance.REF_ADMIN_STORE_POSTS.child(post.postId).child("title").setValue(updatedStoreTitle) { (err, ref) in
            
            // using the dismiss here instead of pop because we are in a naviagation view and it's smoother going back this way
            self.dismiss(animated: true, completion: nil)
        }
        
        
        DataService.instance.REF_ADMIN_STORE_POSTS.child(post.postId).child("storeId").setValue(updatedStoreId) { (err, ref) in
            
            // using the dismiss here instead of pop because we are in a naviagation view and it's smoother going back this way
            self.dismiss(animated: true, completion: nil)
        }
        
        DataService.instance.REF_ADMIN_STORE_POSTS.child(post.postId).child("category").setValue(updatedCategory) { (err, ref) in
            
            // using the dismiss here instead of pop because we are in a naviagation view and it's smoother going back this way
            self.dismiss(animated: true, completion: nil)
        }
        
        DataService.instance.REF_ADMIN_STORE_POSTS.child(post.postId).child("price").setValue(updatedPrice) { (err, ref) in
            
            // using the dismiss here instead of pop because we are in a naviagation view and it's smoother going back this way
            self.dismiss(animated: true, completion: nil)
        }
        
        DataService.instance.REF_ADMIN_STORE_POSTS.child(post.postId).child("poppPrice").setValue(updatedPoppPrice) { (err, ref) in
            
            // using the dismiss here instead of pop because we are in a naviagation view and it's smoother going back this way
            self.dismiss(animated: true, completion: nil)
        }
        
        DataService.instance.REF_ADMIN_STORE_POSTS.child(post.postId).child("points").setValue(updatedPointsRequired) { (err, ref) in
            
            // using the dismiss here instead of pop because we are in a naviagation view and it's smoother going back this way
            self.dismiss(animated: true, completion: nil)
        }
        
        DataService.instance.REF_ADMIN_STORE_POSTS.child(post.postId).child("calories").setValue(updatedCalories) { (err, ref) in
            
            // using the dismiss here instead of pop because we are in a naviagation view and it's smoother going back this way
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        
        guard !textView.text.isEmpty else {
        
            actionButton.isEnabled = false
            actionButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        return
        }
        actionButton.isEnabled = true
        actionButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
    
    @objc func formValidation () {
        guard
            captionTextView.hasText,
            descriptionTextView.hasText,
        storeTitleTextView.hasText,
                storeIdTextView.hasText,
            categoryTextView.hasText,
                priceTextView.hasText,
            poppPriceTextView.hasText,
            caloriesTextView.hasText,
           pointsTextView.hasText == true else {
                
            actionButton.isEnabled = false
            actionButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
            
            return
        }
        
        actionButton.isEnabled = true
        actionButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }

}
