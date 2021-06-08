//
//  UIViewExt.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/6/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

// MARK: - Property Extensions

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func mainPink() -> UIColor {
        return UIColor.rgb(red: 221, green: 94, blue: 86)
    }
    
    static func neonGreen() -> UIColor {
        return UIColor.rgb(red: 74, green: 253, blue: 9)
    }
    
    static func greenSalad() -> UIColor {
        //return UIColor.rgb(red: 255, green: 110, blue: 125)
        return UIColor.rgb(red: 71, green: 190, blue: 13)
        
    }
    
    static func airBnBRed() -> UIColor {
        //return UIColor.rgb(red: 255, green: 110, blue: 125)
        return UIColor.rgb(red: 242, green: 96, blue: 98)
        
    }
    
    static func airBnBDeepRed() -> UIColor {
        return UIColor.rgb(red: 255, green: 55, blue: 100)
    }
    
    static func walkzillaRed() -> UIColor {
        return UIColor.rgb(red: 246, green: 80, blue: 100)
    }
    
    static func airBnBNew() -> UIColor {
        return UIColor.rgb(red: 236, green: 84, blue: 95)
    }
    
    static func statusBarGreen() -> UIColor {
        return UIColor.rgb(red: 49, green: 213, blue: 56)
    }
    
    static func statusBarGreenDeep() -> UIColor {
        return UIColor.rgb(red: 41, green: 205, blue: 48)
    }
    
    static func newWalkzillaRed() -> UIColor {
        return UIColor.rgb(red: 247, green: 0, blue: 59)
    }
    
    
    
    static func actionRed() -> UIColor {
        return UIColor.rgb(red: 236, green: 38, blue: 125)
    }
    
    static func trueBlue() -> UIColor {
        return UIColor.rgb(red: 26, green: 172, blue: 239)
    }
    
    static func mainBlue() -> UIColor {
        return UIColor.rgb(red: 55, green: 120, blue: 250)
    }
    
    static func directionsGreen() -> UIColor {
        return UIColor.rgb(red: 76, green: 217, blue: 100)
    }
    
    
}

extension UIButton {
    
    func configure(didFollow: Bool) {
        
        if didFollow {
            
            // handle follow user
            self.setTitle("Following", for: .normal)
            self.setTitleColor(.black, for: .normal)
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.backgroundColor = .white
            
        } else {
           
            // handle unfollow user
            self.setTitle("Follow", for: .normal)
            self.setTitleColor(.white, for: .normal)
            self.layer.borderWidth = 0
            self.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)

        }
    }
}

extension Date {
    
    func timeAgoToDisplay() -> String {
    
        // the self references seconds ago
        let secondsAgo = Int(Date().timeIntervalSince(self))
    
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
    
        let quotient: Int
        let unit: String
    
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "s"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "h"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "d"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "w"
        } else {
            quotient = secondsAgo / month
            unit = "mo"
        }
        
        // determining whether or not we want to add a letter s to the end of the unit
        //return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        //return "\(quotient)\(unit)\(quotient == 1 ? "" : "") ago"
        return "\(quotient)\(unit)\(quotient == 1 ? "" : "")"
    }
}

extension Int {
    
    // pennies to formatted currency function returns a string of some sort
    func penniesToFormatttedCurrency() -> String {
        
        // if the int this function is being called on is 1234 the dollars = 1234 / 100 = $12.34
        let dollars = Double(self) / 100
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "es_US")
        
        if let dollarString = formatter.string(from: dollars as NSNumber) {
            return dollarString
        }
        return "$0.00"
    }
}


// MARK: - UIView Extensions


extension UIView {
    
    // Funcation used to bind the keyboard to whatever is on the UI screen. The screen moves up with the keyboard animation.
    func bindToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    func addConstraintsToFillView(view: UIView) {
        self.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    func center(inView view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func centerX(inView view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    
    func fadeTo(alphaValue: CGFloat, withDuration duration:TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = alphaValue
        }
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, left:NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
    // Now we use the above values in an animation.
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
            
        }, completion: nil)
    }
}




// MARK: - UIViewController Extensions

extension UIViewController {
    
    func getMentionedUser(withUsername username: String) {
        
        // child added saves us from having to use a for loop
        DataService.instance.REF_USERS.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            
            DataService.instance.REF_USERS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                
                if username == dictionary["username"] as? String {
                    Database.fetchUser(with: uid, completion: { (user) in
                        let userProfileController = UserProfileVC(collectionViewLayout: UICollectionViewFlowLayout())
                        userProfileController.user = user
                        self.navigationController?.pushViewController(userProfileController, animated: true)
                        return
                    })
                }
            })
        }
    }
    
    func uploadMentionNotification(forPostId postId: String, withText text: String, isForComment: Bool) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let creationDate = Int(NSDate().timeIntervalSince1970)
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        
        var mentionIntegerValue: Int!
        
        // determining whether our mention is for a comment or post based on the boolean variable set above
        if isForComment {
            mentionIntegerValue = COMMENT_MENTION_INT_VALUE
        } else {
            mentionIntegerValue = POST_MENTION_INT_VALUE
        }
        
        for var word in words {
            if word.hasPrefix("@") {
                word = word.trimmingCharacters(in: .symbols)
                word = word.trimmingCharacters(in: .punctuationCharacters)
                
                DataService.instance.REF_USERS.observe(.childAdded) { (snapshot) in
                    let uid = snapshot.key
                    
                    DataService.instance.REF_USERS.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                        
                        if word == dictionary["username"] as? String {
                            
                            let notificationValues = ["postId": postId,
                                                      "uid": currentUid,
                                                      "type": mentionIntegerValue,
                                                      "creationDate": creationDate] as [String: Any]
                            
                            if currentUid != uid {
                                DataService.instance.REF_NOTIFICATIONS.child(uid).childByAutoId().updateChildValues(notificationValues)
                            }
                        }
                    })
                }
                
            }
        }
    }
}


// MARK: - Database Extensions

extension Database {
    
    static func fetchUser(with uid: String, completion: @escaping(User) -> ()) {
        
        DataService.instance.REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            
            let user = User(uid: uid, dictionary: dictionary)
            
            //print("This is the user to append \(user)")
            completion(user)
        }
    }
    
    static func fetchLeaderboardUser(with uid: String, completion: @escaping(User) -> ()) {
        
        // get current date
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" //"dd.MM.yyyy"
        let result = formatter.string(from: date)
        print("this is the current date \(result)")
            
        DataService.instance.REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
        
            
            let user = User(uid: uid, dictionary: dictionary)
 
            print("this should be the activity date \(user.activityDate)")
            
            // add this boolean value once we have a consistent amount of data to run against. would like to capture it over a weeks period
            
            //if user.activityDate == result {
                
                completion(user)
           // }

        }
        
    }
    
    
    static func fetchCategoryPosts(with postId: String, completion: @escaping(Category) -> ()) {
        DataService.instance.REF_CATEGORIES.child(postId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            let post = Category(postId: postId, dictionary: dictionary)
            
            completion(post)
        }
    }
    
    static func fetchActivity(with tripId: String, completion: @escaping(Activity) -> ()) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_ACTIVITY.child(currentUid).child(tripId).observeSingleEvent(of: .value) { (snapshot) in
            
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                       
                let activityData = Activity(tripId: tripId, dictionary: dictionary)
                       
                       completion(activityData)
        }
    }
    
    /*
    static func fetchDailyActivity(with uid: String, completion: @escaping(User) -> ()) {
        //guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USERS.child(uid).child("temp-daily-activity-total").observeSingleEvent(of: .value) { (snapshot) in
            
            
            print("HOW MANY TIMES IS THIS CALLED")
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                       
                let user = User(uid: uid, dictionary: dictionary)
                       
                       completion(user)
        }
    }
    */
    
    static func fetchRewards(with storeId: String, completion: @escaping(Rewards) -> ()) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        DataService.instance.REF_USER_REWARDS.child(currentUid).child(storeId).observeSingleEvent(of: .value) { (snapshot) in
            
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                       
                let rewardsData = Rewards(storeId: storeId, dictionary: dictionary)
                       
                       completion(rewardsData)
        }
    }
    
    static func fetchUserGroups(with groupId: String, completion: @escaping(UserGroup) -> ()) {
        DataService.instance.REF_USER_GROUPS.child(groupId).observeSingleEvent(of: .value) { (snapshot) in
            
                guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
                       
                let group = UserGroup(groupId: groupId, dictionary: dictionary)
                       
                completion(group)
        }
    }
    
    
    static func fetchPost(with postId: String, completion: @escaping(Post) -> ()) {
        DataService.instance.REF_POSTS.child(postId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let ownerUid = dictionary["ownerUid"] as? String else { return }  // Parsing through JSON data.
            
            Database.fetchUser(with: ownerUid, completion: { (user) in
                
                let post = Post(postId: postId, user: user, dictionary: dictionary)
                
                completion(post)
            })
        }
    }
    
    static func fetchChatroomMessages(with chatId: String, groupId: String, completion: @escaping(ChatroomMessage) -> ()) {
        DataService.instance.REF_GROUP_MESSAGES.child(groupId).child(chatId).observeSingleEvent(of: .value) { (snapshot) in
        
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let fromId = dictionary["fromId"] as? String else { return }  // Parsing through JSON data.
            
            print("THIS IS THE OWNER ID \(fromId)")
            
            Database.fetchUser(with: fromId, completion: { (user) in
                
                
                let chat = ChatroomMessage(dictionary: dictionary)
                
                completion(chat)
            })
        }
    }
    
    static func fetchSearchPost(with postId: String, completion: @escaping(Post) -> ()) {
        DataService.instance.REF_POSTS.child(postId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let ownerUid = dictionary["ownerUid"] as? String else { return }  // Parsing through JSON data.
            guard let type = dictionary["type"] as? String else { return }
            
            print("This is the value of the dictionary \(type)")
            
            if type == "userPost" {
            Database.fetchUser(with: ownerUid, completion: { (user) in
                
                let post = Post(postId: postId, user: user, dictionary: dictionary)
                
                completion(post)
            })
            } else {
                print("do nothing")
            }
            
        }
    }
    
    
    // here we use trip ID to find post under the activity section
    static func fetchStorePost(with postId: String, completion: @escaping(StorePost) -> ()) {

        DataService.instance.REF_ADMIN_STORE_POSTS.child(postId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let ownerUid = dictionary["ownerUid"] as? String else { return }  // Parsing through JSON data.
            
            Database.fetchUser(with: ownerUid, completion: { (user) in
                
                let post = StorePost(postId: postId, user: user, dictionary: dictionary)
                
                completion(post)
            })
        }
    }
    
    static func fetchStoreLogos(with postId: String, logoId: String, completion: @escaping(Logos) -> ()) {
       // guard let currentUid = Auth.auth().currentUser?.uid else { return }
        DataService.instance.REF_POSTS.child(postId).child("logoImages").child(logoId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            print("The image SNAPSHOT IS GOING TO BE \(snapshot)")
                           
                let post = Logos(postId: postId, dictionary: dictionary)
            print("The image URL IS GOING TO BE \(post.logoUrl)")
                completion(post)
    
        }
    }
    
    
    static func fetchAnimatedLogo(with postId: String, logoNum: String, completion: @escaping(Logos) -> ()) {
    
        
        
        DataService.instance.REF_POSTS.child(postId).child("logoImages").child(logoNum).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
     
            //print("The logo snapshot value is  \(snapshot.value)")
            
            let post = Logos(postId: postId, dictionary: dictionary)
        
            
                completion(post)
    
        }
    }
    
    static func fetchLogos(with postId: String, completion: @escaping(Logos) -> ()) {
        

            
        DataService.instance.REF_POSTS.child(postId).child("logoImages").observeSingleEvent(of: .value) { (snapshot) in
            
        //DataService.instance.REF_POSTS.child(postId).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            
            print("CAN WE SEE THE LOGOS SNAPSHOT \(snapshot)")
            let post = Logos(postId: postId, dictionary: dictionary)

            // this value must escape Logos as well
            completion(post)
        
            
            /*
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            guard let ownerUid = dictionary["ownerUid"] as? String else { return }  // Parsing through JSON data.
            
            Database.fetchUser(with: ownerUid, completion: { (user) in
                
                let post = Post(postId: postId, user: user, dictionary: dictionary)
                
                completion(post)
            })
            */
        }
   
    }
    
    static func sizeOfImageAt(url: URL) -> CGSize? {
         // with CGImageSource we avoid loading the whole image into memory
         guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
             return nil
         }

         let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
         guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
             return nil
         }

         if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
             let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
             return CGSize(width: width, height: height)
         } else {
             return nil
         }
     }
    
    
    static func fetchDimensions(with url: URL, completion: @escaping(UIImage) -> ()) {
                                
        URLSession.shared.dataTask(with: url) {data,error,_ in ()
                    
                    // Handle our error
                    if let error = error {
                        print("Failed to load image with error")
                    }
                    // Image data.
                    guard let imageData = data else { return }

                    // Set image using image data.
            guard let photoImage = UIImage(data: imageData) else { return }
            
                //self.imageWidth = photoImage?.size.width
                //self.imageHeight = photoImage?.size.height
                    
                    completion(photoImage)
                
                    }.resume()
    }
    
    static func fetchStore(with storeId: String, completion: @escaping(Store) -> ()) {
        
        DataService.instance.REF_STORES.child(storeId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            //guard let title = dictionary["title"] as? String else { return }  // Parsing through JSON data.
            
            
            let store = Store(storeId: storeId, dictionary: dictionary)

            completion(store)
            
            /*Database.fetchStore(with: title, completion: { (user) in  // not sure if this should be user
                
                let store = Store(storeId: storeId, dictionary: dictionary)
                print(storeId)
                completion(store)
            }) */
        }
    }
    
    
    static func fetchCategory(with categoryId: String, completion: @escaping(MarketCategory) -> ()) {
        
        DataService.instance.REF_MARKETPLACE.child(categoryId).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String, AnyObject> else { return }
            //guard let title = dictionary["title"] as? String else { return }  // Parsing through JSON data.
            
            
            let category = MarketCategory(categoryId: categoryId, dictionary: dictionary)

            completion(category)
            // this category should be able to find the post and the category
            
            /*Database.fetchStore(with: title, completion: { (user) in  // not sure if this should be user
                
                let store = Store(storeId: storeId, dictionary: dictionary)
                print(storeId)
                completion(store)
            }) */
        }
    }
}


