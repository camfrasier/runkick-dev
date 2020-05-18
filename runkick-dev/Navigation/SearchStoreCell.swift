//
//  SearchStoreCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 10/15/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import MapKit
import Firebase

protocol SearchStoreCellDelegate {
    func distanceFromUser(searchLocation: CLLocation) -> CLLocationDistance?
}

class SearchStoreCell: UITableViewCell, CLLocationManagerDelegate {
    
    // MARK: - Properties
    
    var delegate: SearchStoreCellDelegate?
    var homeVC: HomeVC?
    var userLocation: String?
    var currentLocation: CLLocation!
    var manager: CLLocationManager?
    
    var store: Store? {
        didSet {
            //guard let profileImageUrl = user?.profileImageURL else { return }
            guard let storeName = store?.title else { return }
            guard let storeAddress = store?.location else { return }
            guard let storeLat = store?.lat else { return }
            guard let storeLong = store?.long else { return }

            let coordinatePin = CLLocationCoordinate2DMake(storeLat, storeLong)
            let destinationPin = MKPlacemark(coordinate: coordinatePin)
            
            mapItem = MKMapItem(placemark: destinationPin)
            
            
            guard let userLocation = manager?.location else { return }
            //print("The user LOCATION IS THIS...\(userLocation)")
                
            guard let mapItemLocation = mapItem?.placemark.location else { return }
            //print("Map item location \(mapItemLocation)")
                
            //calculating the distance from user here
            let distanceFromUser = userLocation.distance(from: mapItemLocation)
                
            //print("This is the DISTANCE FROM USER\(distanceFromUser)")
            
            let distanceFormatter = MKDistanceFormatter()
            distanceFormatter.unitStyle = .abbreviated
            
            let distanceAsString = distanceFormatter.string(fromDistance: distanceFromUser)
            locationDistanceLabel.text = ("\(distanceAsString)")
            
            //print("This is the DISTANCE FROM USER\(distanceAsString)")
            
            //profileImageView.loadImage(with: profileImageUrl)
            
            self.textLabel?.text = storeName
            self.detailTextLabel?.text = storeAddress
        }
    }
    
    var mapItem: MKMapItem?
    

    let storeImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "simpleGrayCircleForkKnife")
        iv.backgroundColor = .white
        //iv.tintColor = .lightGray
        return iv
    } ()
    
    let locationDistanceLabel: UILabel = {
        let label = UILabel()
        label.text = "5.5mi"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(red: 110/255, green: 110/255, blue: 110/255, alpha: 1)
        return label
    } ()
    
    // MARK: Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        self.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationUpdateNotification), name: NSNotification.Name("UserLocationNotification"), object: nil)
        
        manager = CLLocationManager()
        manager?.delegate = self
        
        calculateUserDistance()
        
       
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
 
        //textLabel?.frame = CGRect(x: 75, y: textLabel!.frame.origin.y, width: self.frame.width, height: (textLabel?.frame.height)!)
        textLabel?.frame = CGRect(x: 35, y: textLabel!.frame.origin.y, width: self.frame.width, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.systemFont(ofSize: 17)
        
        //detailTextLabel?.frame = CGRect(x: 75, y: detailTextLabel!.frame.origin.y, width: self.frame.width, height: detailTextLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 35, y: detailTextLabel!.frame.origin.y, width: self.frame.width, height: detailTextLabel!.frame.height)
        detailTextLabel?.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        
        addSubview(locationDistanceLabel)
        locationDistanceLabel.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 35, width: 0, height: 0)
        locationDistanceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        /*
        // Add image view
               let dimension: CGFloat = 45
               addSubview(storeImageView)
               storeImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 0, width: dimension, height: dimension)
               storeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
               storeImageView.layer.cornerRadius = dimension / 2
               storeImageView.clipsToBounds = true
               */
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func locationUpdateNotification(_ notification: NSNotification) {
        
        //print(notification.userInfo?["location"] as Any)
        
        //let value = (notification.userInfo?["location"] as Any)
        let value = notification.userInfo! as NSDictionary
        

        //print("THIS IS A RAW VALUE \(value)")
       
        //print(notification.userInfo?.)
        
        /*
        if let userInfo = notification.userInfo?["location"] as? CLLocation {
            
            print("We reach the notification function!!!")
            self.currentLocation = userInfo
            self.userLocation = "\(userInfo.coordinate.latitude), \(userInfo.coordinate.longitude)"
            
        }
        */
    }
    
    /*
    func distanceFromUser(searchLocation: CLLocation) -> CLLocationDistance? {
        
        guard let userLocation = homeVC?.manager?.location else { return nil }
        return userLocation.distance(from: searchLocation)
        
        let distanceFormatter = MKDistanceFormatter()
        distanceFormatter.unitStyle = .abbreviated
        
        guard let distanceFromUser = userLocation.distance(from: searchLocation) else { return }
        
        let distanceAsString = distanceFormatter.string(fromDistance: distanceFromUser)
        //locationDistanceLabel.text = ("\(distanceAsString)")
        
        //print("\(distanceAsString)")
    }
    */
    
    func calculateUserDistance() {
        
        
        
        //let distanceFormatter = MKDistanceFormatter()
        //distanceFormatter.unitStyle = .abbreviated
        
        //let distanceAsString = distanceFormatter.string(fromDistance: distanceFromUser)
        //locationDistanceLabel.text = ("\(distanceAsString)")
        

    }
    
 
    /*
    func configureUserLocationCell(userLocation: CLLocation) {
        
        let location = userLocation
        
        //plotting of all store coordinates in array happens here
        //guard let mapItemLocation = mapItem?.placemark.location else { return }
        
        currentLocation = userLocation
        calculateStoreDistance(location: location)
             
        // plotting of all store coordinates in array happens here
        // guard let mapItemLocation = mapItem?.placemark.location else { return }
        
    }
    
    func calculateStoreDistance(location: CLLocation) {
        
        print("DEBUG: Here is the proper location")
    }
    
     */
    func calculateDistance() {
        
        //guard let location = currentLocation else { return }
        //print("THE USERS CURRENT LOCATION IS \(location)")
        
        // plotting of all store coordinates in array happens here
        guard let mapItemLocation = mapItem?.placemark.location else { return }
        print("This is my mapitem\(mapItemLocation)")
        
        let distanceFormatter = MKDistanceFormatter()
        distanceFormatter.unitStyle = .abbreviated
        
        
        //searchCellDelegate?.distanceFromUser(searchLocation: mapItemLocation)
        
        guard let distanceFromUser = delegate?.distanceFromUser(searchLocation: mapItemLocation) else { return }
        print("THIS IS THE DISTANCE \(distanceFromUser)")
        
        // calculating the distance from user here
        //guard let distanceFromUser = currentLocation?.distance(from: mapItemLocation) else { return }
        
        
        //print("This is the DISTANCE FROM USER\(distanceFromUser)")
        
        //let distanceFormatter = MKDistanceFormatter()
        //distanceFormatter.unitStyle = .abbreviated
        
        //let distanceAsString = distanceFormatter.string(fromDistance: distanceFromUser)
        //locationDistanceLabel.text = ("\(distanceAsString)")
        
        //print("\(distanceAsString)")
        
    }
    
    
    
    
}
