//
//  UpdateService.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/24/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase

var key = String ()
var currentTripId = String ()
var tripIdConfigured = false
let creationDate = Int(NSDate().timeIntervalSince1970)

class UpdateService {
    static var instance = UpdateService()
    
    func resetTripId() {
        tripIdConfigured = false
    }
    
    // Below function will allow the app to monitor the runner location.
    func updateUserLocation(withCoordinate coordinate: CLLocationCoordinate2D) {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
    // Parsing through all the user in userSnapshot within Firebase.
                for user in userSnapshot {
                    if user.key == Auth.auth().currentUser?.uid {
                        DataService.instance.REF_USERS.child(user.key).updateChildValues(["usercoordinate": [coordinate.latitude, coordinate.longitude]])
        
                    }
                }
            }
        })
    } // This is from the Udemy course 15. We won't need the driver location.
    
    func updateDestinationToNewOrigin(withCoordinate coordinate: CLLocationCoordinate2D) {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for user in userSnapshot {
                    if user.key == Auth.auth().currentUser?.uid {
                        DataService.instance.REF_USERS.child(user.key).updateChildValues(["usercoordinate": [coordinate.latitude, coordinate.longitude]])
                    }
                }
            }
        })
    }
    
    func observeTrips(handler: @escaping(_ coordinateDict: Dictionary<String, AnyObject>?) -> Void) {
        DataService.instance.REF_TRIPS.observe(.value, with: { (snapshot) in
            if let tripSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for trip in tripSnapshot {
                    if trip.hasChild("runnerKey") {
                    // Below casting as data we can user in our app.
                        if let tripDict = trip.value as? Dictionary<String, AnyObject> {
                        handler(tripDict) // Passing in trip dictionary into our handler.
                        }
                    }
                }
            }
        })
    }
    
    // after save segment this should get updated.. and we need to create a trip level under the UID
    
    func updateTripsWithCoordinatesUponSelect() {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for user in userSnapshot {
                    if user.key == Auth.auth().currentUser?.uid {
                        if !user.hasChild("userIsStoreadmin") {
                            if let userDict = user.value as? Dictionary<String, AnyObject> {
                                //let originationArray = userDict["usercoordinate"] as! NSArray
                                let destinationArray = userDict["tripCoordinate"] as! NSArray
                                
                                /* DataService.instance.REF_TRIPS.child(user.key).childByAutoId().updateChildValues(["originationCoordinate": [originationArray[0],originationArray[1]], "destinationCoordinate": [destinationArray[0], destinationArray[1]], "runnerKey": user.key]) */
                                
                                // Trips > user id > trip id > path id > destination coordinate id / timestamp
                                // We can use the coordinates here to determine the store name and additional info
                                
                                if tripIdConfigured == false {
                               // if tripId exists
                                DataService.instance.REF_TRIPS.child(user.key).childByAutoId().childByAutoId().updateChildValues(["destinationCoordinate": [destinationArray[0], destinationArray[1]], "runnerKey": user.key, "creationDate": creationDate])
                                    
                                tripIdConfigured = true
                                } else {
                                    
                                    print("The tripId has been configured")
                                    DataService.instance.REF_TRIPS.child(user.key).child(currentTripId).childByAutoId().updateChildValues(["destinationCoordinate": [destinationArray[0], destinationArray[1]], "runnerKey": user.key, "creationDate": creationDate])
                                    
                                }
                                
                            }
                        }
                    }
                }
            }
        })
    }
    
    func saveTripSegment(forRunnerKey runnerKey: String) {
        // may not need to save runner key here. will need to come back to determine
        DataService.instance.REF_USERS.child(runnerKey).updateChildValues(["runnerKey": runnerKey, "segmentIsSaved": true])
        
        // observe the last trip within trip history
        DataService.instance.REF_TRIPS.child(runnerKey).queryLimited(toLast: 1).observe(.childAdded) {(snapshot: DataSnapshot) in
            let tripId = snapshot.key
            print("DEBUG: TRIP ID \(tripId)")
            
            currentTripId = tripId
            
            // then observe the last segment entry within the trip
            DataService.instance.REF_TRIPS.child(runnerKey).child(tripId).queryLimited(toLast: 1).observe(.childAdded) {(snapshot: DataSnapshot) in
                key = snapshot.key
                
                print("DEBUG: LAST SEGMENT KEY VALUE \(key)" )
            }
        }
    }
    
    func cancelTripSegment(forRunnerKey runnerKey: String) {
        //print(key)
        DataService.instance.REF_TRIPS.child(runnerKey).child(currentTripId).child(key).removeValue()
        DataService.instance.REF_USERS.child(runnerKey).child("tripCoordinate").removeValue()
        DataService.instance.REF_USERS.child(runnerKey).updateChildValues(["segmentIsSaved": false])
    }
}
