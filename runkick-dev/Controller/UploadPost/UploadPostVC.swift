//
//  UploadPostVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/19/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class UploadPostVC: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    
    // enumeration that helps with changing the share button value depending on whether we are uploading or editing
    enum UploadAction: Int {
        case UploadPost
        case SaveChanges
        case UploadVideoPost
        
        // initialize enum with uploadpost action
        init(index: Int) {
            switch index {
            case 0: self = .UploadPost
            case 1: self = .SaveChanges
            case 2: self = .UploadVideoPost
            default: self = .UploadPost
            }
        }
    }
    
    var uploadAction: UploadAction!
    var selectedImage: UIImage?
    var selectedVideo: URL?
    var postToEdit: Post?
    var isVideoPost = false
    //var image: UIImage?
    
    let photoImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    } ()
    
    lazy var saveImage: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Image", for: .normal)
        button.addTarget(self, action: #selector(handleSaveImage), for: .touchUpInside)
        button.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //button.layer.borderWidth = 1
        //button.layer.borderColor = UIColor.rgb(red: 0, green: 0, blue: 0).cgColor
        button.alpha = 1
        return button
    }()
    
    lazy var saveVideo: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Video", for: .normal)
        button.addTarget(self, action: #selector(handleSaveImage), for: .touchUpInside)
        button.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //button.layer.borderWidth = 1
        //button.layer.borderColor = UIColor.rgb(red: 0, green: 0, blue: 0).cgColor
        button.alpha = 1
        return button
    }()
    
    let captionTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = UIColor.groupTableViewBackground
        tv.font = UIFont.systemFont(ofSize: 14)
        
        return tv
    } ()

    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 235)
        button.setTitle("Share", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleUploadAction), for: .touchUpInside)
        button.isEnabled = false // Disable the button until we have a caption.
        return button
    } ()
    
    // MARK: - Init
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure view components.
        configureViewComponents()
        
        // Load the image.
        loadImage()
        
        print("The bool variable for theis vide is set to \(isVideoPost)")

        
        captionTextView.delegate = self // Just telling our program that this view controller will be the delegate for handling all the data.
        
        view.backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 240)
    }
    
    // using view will appear because view did load actually only calls once, which is not the case in view did appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        if uploadAction == .SaveChanges {
            guard let post = self.postToEdit else { return }
            actionButton.setTitle("Save Changes", for: .normal)
            self.navigationItem.title = "Edit Post"
            //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
            navigationController?.navigationBar.tintColor = .black
            
            photoImageView.loadImage(with: post.imageUrl)
            captionTextView.text = post.caption
        } else {
            actionButton.setTitle("Share", for: .normal)
            self.navigationItem.title = "Upload Post"
            //navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
            navigationController?.navigationBar.tintColor = .black
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - UITextView
    
    func textViewDidChange(_ textView: UITextView) {
        
        guard !textView.text.isEmpty else {
        
            actionButton.isEnabled = false
            actionButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        return
        }
        actionButton.isEnabled = true
        actionButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
    
    // MARK: - Handlers
    
    func updateUserFeeds(with postId: String) {
        
        // current user id
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // database values
        let values = [postId: 1]
        
        // update our follower feeds
        DataService.instance.REF_FOLLOWER.child(currentUid).observe(.childAdded) { (snapshot) in
            
            let followerUid = snapshot.key
            DataService.instance.REF_FEED.child(followerUid).updateChildValues(values)
        }
        
        // update current user feed.
        DataService.instance.REF_FEED.child(currentUid).updateChildValues(values)
        
    }
    
    // Use this if you have a UITextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)

        // make sure the result is under 16 characters
        return updatedText.count <= 240
    }
    
    @objc func handleUploadAction() {
        
        buttonSelector(uploadAction: uploadAction)
    }
    
    
    @objc func handleCancel() {
        
        print("the cancel button should work here")
        //self.dismiss(animated: true, completion: nil)
        
        //self.navigationController?.popViewController(animated: true)
        
       // self.navigationController?.dismiss(animated: true)
    }
    
    @objc func handleSaveImage() {
        
        // if user toggles save the image will save
        print("save current image")
        guard let imageToSave = selectedImage else {
            return
        }
            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
            //dismiss(animated: false, completion: nil)
        
    }
    
    @objc func handleSaveVideo() {
        
   
        print("save current video")
       
       // UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, #selector(self.video(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    func buttonSelector(uploadAction: UploadAction) {
        
        switch uploadAction {
            
        case .UploadPost:
            handleUploadPost()

        case .SaveChanges:
            handleSavePostChanges()
            
        case .UploadVideoPost:
            handleUploadVideo(url: selectedVideo!)
            isVideoPost = true
            
        }
    }
    
    func handleSavePostChanges() {
        guard let post = self.postToEdit else { return }
        let updatedCaption = captionTextView.text
        
        uploadHastagToServer(withPostId: post.postId)
        
        DataService.instance.REF_POSTS.child(post.postId).child("caption").setValue(updatedCaption) { (err, ref) in
            
            // using the dismiss here instead of pop because we are in a naviagation view and it's smoother going back this way
            
            //self.navigationController?.popViewController(animated: true)
            
        }
    }
    
func handleUploadVideo(url: URL) {
    
    
            let name = "\(NSUUID().uuidString).mp4"
            let creationDate = Int(NSDate().timeIntervalSince1970)
            //let name = "\(Int(Date().timeIntervalSince1970)).mp4"
            let path = NSTemporaryDirectory() + name

            let dispatchgroup = DispatchGroup()
            
            // Parameters
            guard
                let caption = captionTextView.text,
                //let postImg = photoImageView.image,
                let currentUid = Auth.auth().currentUser?.uid else { return }
    
    print("WE ARE PLANNING TO UPLOAD a VID AND HERE IS THE URL \(url)")
            dispatchgroup.enter()

            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let outputurl = documentsURL.appendingPathComponent(name)
            var ur = outputurl
    
    
    // i believe my data has already been converted
    
            self.convertVideo(toMPEG4FormatForVideo: url as URL, outputURL: outputurl) { (session) in

                ur = session.outputURL!
                dispatchgroup.leave()

            }
            dispatchgroup.wait()

            let data = NSData(contentsOf: ur as URL)

            do {

                try data?.write(to: URL(fileURLWithPath: path), options: .atomic)

            } catch {

                print(error)
            }

            let storageRef = Storage.storage().reference().child("video_posts").child(name)
           
            if let uploadData = data as Data? { storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
              guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
              }
              // Metadata contains file metadata such as size, content-type.
              //let size = metadata.size
              // You can also access to download URL after upload.
                
                
                storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                  // Uh-oh, an error occurred!
                  return
                }
                    let postVideoUrl = (url?.absoluteString)!
                    print(postVideoUrl)
                    
                    let values = ["caption": caption,
                                  "creationDate": creationDate,
                                  "likes": 0,
                                  "videoUrl": postVideoUrl,
                                  "type": "videoPost",
                                  "ownerUid": currentUid] as [String: Any]
                    
                    
                    let postId = DataService.instance.REF_POSTS.childByAutoId()
                    let userPostId = DataService.instance.REF_USER_POSTS
                    // Upload information to database.
                    
                    postId.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        
                        guard let postKey = postId.key else { return }
                        // update user post section.
                        userPostId.child(currentUid).updateChildValues([postKey: 1])
                        
                        // update user feed structure
                        self.updateUserFeeds(with: postKey)
                        
                        // upload hashtag to server
                        self.uploadHastagToServer(withPostId: postKey)
                        
                        // upload mention notification to server
                        if caption.contains("@") {
                            self.uploadMentionNotification(forPostId: postKey, withText: caption, isForComment: false)
                        }

                        // confirming image landscape or profile
                        let convertedUrl = downloadURL
                        Database.fetchDimensions(with: convertedUrl) { (photoImage) in
                            let imageWidth = photoImage.size.width
                            let imageHeight = photoImage.size.height
                            
                            print("this is the photo width \(imageWidth) and this is the height \(imageHeight)")
                            if imageWidth > imageHeight {
                                postId.updateChildValues(["photoStyle": "landscape"])
                            } else {
                                 postId.updateChildValues(["photoStyle": "portrait"])
                            }
                        }
                        
                    })
      
              }
            })
        }
 
    }
    
    
    func convertVideo(toMPEG4FormatForVideo inputURL: URL, outputURL: URL, handler: @escaping (AVAssetExportSession) -> Void) {
        
        //try! FileManager.default.removeItem(at: outputURL as URL)
        let asset = AVURLAsset(url: inputURL as URL, options: nil)

        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously(completionHandler: {
            handler(exportSession)
        })
    }
    
    func handleUploadPost() {
        
        
        // Parameters
        guard
            let caption = captionTextView.text,
            let postImg = photoImageView.image,
            let currentUid = Auth.auth().currentUser?.uid else { return }
        
        // Get image upload data.
        //guard let uploadData = postImg.jpegData(compressionQuality: 0.3) else { return }
        guard let uploadData = postImg.jpegData(compressionQuality: 1) else { return }
        
        
        
        // Update storage
        let filename = NSUUID().uuidString
        let creationDate = Int(NSDate().timeIntervalSince1970)
        let storageRef = Storage.storage().reference().child("profile_images").child(filename)
        
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
                                  "likes": 0,
                                  "imageUrl": postImageUrl,
                                  "type": "userPost",
                                  "ownerUid": currentUid] as [String: Any]
                    
                    // Post id.
                    let postId = DataService.instance.REF_POSTS.childByAutoId()
                    let userPostId = DataService.instance.REF_USER_POSTS
                    // Upload information to database.
                    
                    postId.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        
                        guard let postKey = postId.key else { return }
                        // update user post section.
                        userPostId.child(currentUid).updateChildValues([postKey: 1])
                        
                        // update user feed structure
                        self.updateUserFeeds(with: postKey)
                        
                        // upload hashtag to server
                        self.uploadHastagToServer(withPostId: postKey)
                        
                        // upload mention notification to server
                        if caption.contains("@") {
                            self.uploadMentionNotification(forPostId: postKey, withText: caption, isForComment: false)
                        }
                        
                        
                        // confirming image landscape or profile
                        let convertedUrl = URL(string: postImageUrl)!
                        Database.fetchDimensions(with: convertedUrl) { (photoImage) in
                            let imageWidth = photoImage.size.width
                            let imageHeight = photoImage.size.height
                            
                            print("this is the photo width \(imageWidth) and this is the height \(imageHeight)")
                            if imageWidth > imageHeight {
                                postId.updateChildValues(["photoStyle": "landscape"])
                            } else {
                                 postId.updateChildValues(["photoStyle": "portrait"])
                            }
                        }
                        
                        /*
                        // return to home feed.
                        self.dismiss(animated: true, completion: {
                            self.tabBarController?.selectedIndex = 2
                            
                        })
                        */
                        
                    })

                }
            })
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureViewComponents() {
        
        // Note that 92 is the correct padding needed from the top of the Nav menu.
        view.addSubview(photoImageView)
        photoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top: view.topAnchor, left: photoImageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 92, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 100)
        
        view.addSubview(actionButton)
        actionButton.anchor(top: photoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 24, paddingBottom: 0, paddingRight: 24, width: 0, height: 40)
        
        
        if isVideoPost {
            view.addSubview(saveVideo)
            saveVideo.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 60, paddingBottom: 50, paddingRight: 0, width: 100, height: 50)
            //saveImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            saveVideo.layer.cornerRadius = 15
            
        } else {
     
            view.addSubview(saveImage)
            saveImage.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 60, paddingBottom: 50, paddingRight: 0, width: 100, height: 50)
            //saveImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            saveImage.layer.cornerRadius = 15

    }
        
        
        

        

        
    }
    
    func loadImage() {
    
        guard let selectedImage = self.selectedImage else { return }
        
        photoImageView.image = selectedImage
        
    }
    
    // MARK: - API
    
    func uploadHastagToServer(withPostId postId: String) {
        
        guard let caption = captionTextView.text else { return }
        
        // loop though all captions and search for words with a hashtag in front of them
        let words: [String] = caption.components(separatedBy: .whitespacesAndNewlines)
        
        for var word in words {
            
            if word.hasPrefix("#") {
                // below lines to confirm that we aren't getting any spaces or odd characters
                word = word.trimmingCharacters(in: .punctuationCharacters)
                word = word.trimmingCharacters(in: .symbols)
                
                let hashtagValues = [postId : 1]
                
                DataService.instance.REF_HASHTAG_POST.child(word.lowercased()).updateChildValues(hashtagValues)
            }
        }
    }

}
