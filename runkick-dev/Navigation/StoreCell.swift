//
//  StoreCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 7/15/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import MapKit
import Firebase

protocol StoreCellDelegate {
    func distanceFromUser(location: CLLocation) -> CLLocationDistance?
    func saveSelectedPath(forMapItem mapItem: MKMapItem)
    func removeSelectedPath(forMapItem mapItem: MKMapItem)
}

class StoreCell: UITableViewCell {
    
    // MARK: - Properties
    
    var delegate: StoreCellDelegate?
    var homeVC: HomeVC?
    var stores = [Store]()
    
    var mapItem: MKMapItem? {
        didSet {
            configureCell()
        }
    }
    
    lazy var saveSegmentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plusSignInCircle"), for: .normal)
        //button.addTarget(self, action: #selector(handleSaveSegment), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleSaveSegment), for: .touchUpInside)
        button.tintColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        //button.tintColor = UIColor(red: 9/255, green: 171/255, blue: 231/255, alpha: 1)
        button.alpha = 1
        button.backgroundColor = .clear
        return button
    } ()
    
    lazy var saveSegmentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)

        let attributedText = NSMutableAttributedString(string: "Save it!", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        label.attributedText = attributedText
        
        // add gesture recognizer
        let saveItTap = UITapGestureRecognizer(target: self, action: #selector(handleSaveSegment))
        saveItTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(saveItTap)
        return label
    } ()
    
     
    
    lazy var removeSegmentButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(UIImage(named: "leftMenuArrow"), for: .normal)
        button.setImage(UIImage(named: "minusSignInCircle"), for: .normal)
        button.addTarget(self, action: #selector(handleRemovedSaveSegment), for: .touchUpInside)
        button.tintColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        button.alpha = 1
        button.backgroundColor = .clear
        return button
    } ()
    
    lazy var removeSegmentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)

        let attributedText = NSMutableAttributedString(string: "Lose it", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)])
        label.attributedText = attributedText
        
        // add gesture recognizer
        let removeItTap = UITapGestureRecognizer(target: self, action: #selector(handleRemovedSaveSegment))
        removeItTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(removeItTap)
        return label
    } ()
 
     
   /*
    lazy var saveSegmentButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.titleLabel?.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "Keep it!", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "Save current segment", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.titleLabel?.attributedText = attributedText
        button.setTitle("Keep it!", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byCharWrapping
        
        button.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        button.setTitleColor(UIColor(red: 9/255, green: 171/255, blue: 231/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleSaveSegment), for: .touchUpInside)
        button.layer.borderColor = UIColor(red: 9/255, green: 171/255, blue: 231/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.alpha = 1
        return button
    }()
    
    
    lazy var removeSegmentButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.titleLabel?.textAlignment = .center

        let attributedText = NSMutableAttributedString(string: "Go back", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedText.append(NSAttributedString(string: "Remove last segment", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.white]))
        button.titleLabel?.attributedText = attributedText
        button.setTitle("Go back", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byCharWrapping
        
        button.backgroundColor = UIColor(red: 245/255, green: 242/255, blue: 244/255, alpha: 1)
        button.setTitleColor(UIColor(red: 9/255, green: 171/255, blue: 231/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleRemovedSaveSegment), for: .touchUpInside)
        button.layer.borderColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.alpha = 1
        return button
        
    }()
    */
    
    lazy var imageContainerView: UIView = {   // This is a lazy var because we are adding components to it.
        let view = UIView()
        view.backgroundColor = .lightGray
        view.isUserInteractionEnabled = true
        return view
    } ()
    
    let locationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.rgb(red: 40, green: 40, blue: 40)
        return label
    } ()
    
    lazy var storeImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        iv.isUserInteractionEnabled = true
        return iv
    } ()
    
    
    let locationAddressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.rgb(red: 60, green: 60, blue: 60)
        return label
    } ()
    
    let storeHoursLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Hours: 8am-9pm"
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "All American"
        return label
    }()
    
    let locationPointsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        return label
    } ()
    
    let locationDistanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        return label
    } ()
    
    // Mark: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        addSubview(imageContainerView)
        //let dimension: CGFloat = 140
        imageContainerView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        imageContainerView.layer.cornerRadius = 7
        
        imageContainerView.addSubview(storeImageView)
        storeImageView.anchor(top: imageContainerView.topAnchor, left: imageContainerView.leftAnchor, bottom: imageContainerView.bottomAnchor, right: imageContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        storeImageView.layer.cornerRadius = 7
        
        addSubview(locationTitleLabel)
        locationTitleLabel.anchor(top: topAnchor, left: imageContainerView.rightAnchor, bottom: nil, right: nil
            , paddingTop: 17, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(locationDistanceLabel)
        locationDistanceLabel.anchor(top: locationTitleLabel.topAnchor, left: locationTitleLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 3.5, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(locationAddressLabel)
        locationAddressLabel.anchor(top: locationTitleLabel.bottomAnchor, left: locationTitleLabel.leftAnchor, bottom: nil, right: nil
            , paddingTop: 1, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(categoryLabel)
        categoryLabel.anchor(top: locationAddressLabel.bottomAnchor, left: locationTitleLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(storeHoursLabel)
        storeHoursLabel.anchor(top: categoryLabel.bottomAnchor, left: locationTitleLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        addSubview(locationPointsLabel)
        locationPointsLabel.anchor(top: storeHoursLabel.bottomAnchor, left: locationTitleLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 3, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        
    
        /*
        
        addSubview(saveSegmentButton)
        saveSegmentButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 15, width: 27, height: 27)
 
        addSubview(saveSegmentLabel)
        saveSegmentLabel.anchor(top: saveSegmentButton.bottomAnchor, left: saveSegmentButton.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: -8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        

        addSubview(removeSegmentButton)
        removeSegmentButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        
        addSubview(removeSegmentLabel)
        removeSegmentLabel.anchor(top: removeSegmentButton.bottomAnchor, left: removeSegmentButton.leftAnchor, bottom: nil, right: nil, paddingTop: 4, paddingLeft: -6, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            
        */
        
        
        /*
        addSubview(saveSegmentButton)
        let buttonDimension: CGFloat = 31
        saveSegmentButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 40, width: buttonDimension, height: buttonDimension)
        saveSegmentButton.layer.cornerRadius = buttonDimension / 2.60
        saveSegmentButton.centerY(inView: self)

        addSubview(removeSegmentButton)
        removeSegmentButton.anchor(top: nil, left: nil, bottom: nil, right: saveSegmentButton.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 52, width: buttonDimension, height: buttonDimension)
        removeSegmentButton.layer.cornerRadius = buttonDimension / 2.60
        removeSegmentButton.centerY(inView: self)
        */
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mark: - Selectors
    
    
    
    @objc func handleSaveSegment() {
        
        // make sure here a user CANNOT save or remove segments UNLESS they are users... if they are not logged in send them to logging page
        
        print("segment saved")
        
        let currentUserID = Auth.auth().currentUser?.uid
        
        guard let mapItem = self.mapItem else { return }
        delegate?.saveSelectedPath(forMapItem: mapItem)

        DataService.instance.REF_USERS.child(currentUserID!).updateChildValues(["tripCoordinate": [mapItem.placemark.coordinate.latitude, mapItem.placemark.coordinate.longitude]])
        
        UpdateService.instance.updateTripsWithCoordinatesUponSelect()
        UpdateService.instance.saveTripSegment(forRunnerKey: currentUserID!)
        UpdateService.instance.updateDestinationToNewOrigin(withCoordinate: mapItem.placemark.coordinate)
    }
        
        
        @objc func handleRemovedSaveSegment() {
            
        print("segment removed")
            
        let currentUserID = Auth.auth().currentUser?.uid
        
        guard let mapItem = self.mapItem else { return }
        delegate?.removeSelectedPath(forMapItem: mapItem)
        
        UpdateService.instance.cancelTripSegment(forRunnerKey: currentUserID!)
    }
    
    
    
    /*
    @objc func handleSaveSegment() {
        guard let mapItem = self.mapItem else { return }
        delegate?.saveSelectedPath(forMapItem: mapItem)
        
        let currentUserID = Auth.auth().currentUser?.uid
        
        DataService.instance.REF_USERS.child(currentUserID!).updateChildValues(["tripCoordinate": [mapItem.placemark.coordinate.latitude, mapItem.placemark.coordinate.longitude]])
        
        UpdateService.instance.updateTripsWithCoordinatesUponSelect()
        UpdateService.instance.saveTripSegment(forRunnerKey: currentUserID!)
        UpdateService.instance.updateDestinationToNewOrigin(withCoordinate: mapItem.placemark.coordinate)
        
        animateCancelButtonIn()
 
    }
     
     
    
    @objc func handleRemovedSaveSegment() {
        let currentUserID = Auth.auth().currentUser?.uid
        
        guard let mapItem = self.mapItem else { return }
        delegate?.removeSelectedPath(forMapItem: mapItem)
        
        UpdateService.instance.cancelTripSegment(forRunnerKey: currentUserID!)
        animateCancelButtonOut ()

    }
    */
    
    // MARK: - Helper Functions
    
    /*
    func animateButtonIn() {
        saveSegmentButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
        
            //self.saveSegmentButton.alpha = 1
            self.saveSegmentButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            self.saveSegmentButton.transform = .identity
        }
    }
    
    func animateCancelButtonIn () {
        removeSegmentButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.removeSegmentButton.alpha = 1
            self.removeSegmentButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            self.removeSegmentButton.transform = .identity
        }
    }
    
    func animateCancelButtonOut () {
        removeSegmentButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.removeSegmentButton.alpha = 0
            self.removeSegmentButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            self.removeSegmentButton.transform = .identity
        }
    }
    */
    
    func configureCell() {
        
        /*
        
        var user: User? { // instead of searching in the user i can search the store photo profile.. this may need to be used AFTER i locate the store
            didSet {  // Did set here means we are going to be setting the user for our header in the controller file UserProfileVC.
                
                // Configure edit profile button
                //configureEditProfileFollowButton()
                
                // Set user status
                //setUserStats(for: user)
                
                //let firstname = user?.firstname
                //nameLabel.text = firstname
                
                
                //guard let profileImageUrl = user?.profileImageURL else { return }  // Unwrapping this safely. Use in other functions as well.
                //profileImageView.loadImage(with: profileImageUrl)
         
                // there should be a image in the cell using the image container view
            }
        }
 
        */
        
        //locationTitleLabel.text = mapItem?.name
    
        
        // here i want to go to firebase to find what i need and bring it back to polulate cell
        
        let distanceFormatter = MKDistanceFormatter()
        distanceFormatter.unitStyle = .abbreviated
        guard let mapItemLat = mapItem?.placemark.coordinate.latitude else { return }
        guard let mapItemLong = mapItem?.placemark.coordinate.longitude else { return }
        guard let mapItemLocation = mapItem?.placemark.location else { return }
        
        
        guard let distanceFromUser = delegate?.distanceFromUser(location: mapItemLocation) else { return }
        print("WE NEED THE DISTANCE FROM USER\(distanceFromUser)")
        
        DataService.instance.REF_STORES.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let allObjects = snapshot.children.allObjects as? [DataSnapshot] else { return }
            
            allObjects.forEach({ (snapshot) in
                let storeId = snapshot.key
                
                Database.fetchStore(with: storeId, completion: { (store) in
                    
                    guard let dbStoreLat = store.lat else { return }
                    guard let dbStoreLong = store.long else { return }
                    
                    
                    if dbStoreLat == mapItemLat && dbStoreLong == mapItemLong {
                        //print("the store lat of we are looking for is \(dbStoreLat)")
                        //print("the store long of we are looking for is \(dbStoreLong)")
                        
                        self.locationTitleLabel.text = store.title
                        self.locationAddressLabel.text = store.location
                        self.categoryLabel.text = store.category
                        
                        guard let imageUrl = store.imageUrl else { return }
                        self.storeImageView.loadImage(with: imageUrl)
                        
                        guard let dbStorePoints = store.points else { return }
                        //print("here are your coin \(dbStorePoints)")
                        
                        self.locationPointsLabel.text = String("\(dbStorePoints) points")
                        
                    }
                    
                    
 
                })
            })
        }
        
        
        let distanceAsString = distanceFormatter.string(fromDistance: distanceFromUser)
        locationDistanceLabel.text = ("\(distanceAsString)")
        
    }
    
}
