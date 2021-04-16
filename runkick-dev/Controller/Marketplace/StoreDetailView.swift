//
//  StoreDetailView.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 7/14/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit
import MapKit
import Firebase

private let reuseIdentifier = "StoreCell"

protocol StoreDetailViewDelegate {
    func animateCenterMapButton(expansionState: StoreDetailView.ExpansionState, hideButton: Bool)
    func addPolyline(forDestinationMapItem destinationMapItem: MKMapItem)
    func selectedAnnotation(withMapItem mapItem: MKMapItem)
}

class StoreDetailView: UIView {
    
    // Mark: - Properties
    
    var searchBar: UISearchBar!
    var tableView: UITableView!
    var expansionState: ExpansionState!
    var delegate: StoreDetailViewDelegate?
    var storeDetailView: StoreDetailView!
    var homeVC: HomeVC?
    var filteredStores = [Store]()
    var stores = [Store]()
    var inSearchMode = false    
    var directionsEnabled = false
    var mySwipeUp: UIGestureRecognizer?
    var mySwipeDown: UIGestureRecognizer?
    
    var selectedAnnotationResults: [MKMapItem]? {
        didSet {
            tableView.reloadData()
        }
    } 
    
    enum ExpansionState {
    case NotExpanded
    case SubPartiallyExpanded
    case PartiallyExpanded
    case FullyExpanded
    }
    
    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 2
        view.alpha = 1
        return view
    }()
    
    let saveSegment: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
        label.text = "Save"
        return label
    } ()
    
    let cancelViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "simpleCancelIcon"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissView), for: .touchUpInside)
        button.tintColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1)
        button.alpha = 1
        return button
    }()
    
    lazy var backgroundCancelViewBtn: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 4.0
        let cancelTapped = UITapGestureRecognizer(target: self, action: #selector(handleDismissView))
        cancelTapped.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(cancelTapped)
        return view
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect){
    super.init(frame: frame)
    
    configureViewComponents()
    configureGestureRecognizers()
        
    expansionState = .FullyExpanded
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mark - Helper functions
    
    func animateInputView(targetPosition: CGFloat, completion: @escaping(Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.frame.origin.y = targetPosition
        }, completion: completion)
    }

    func configureViewComponents() {
        
        
        
        layer.backgroundColor = UIColor.rgb(red: 181, green: 201, blue: 215).cgColor
        
        
        
        /*
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 0.15
        
        */
        
        //let height: CGFloat = 50
        //let viewY = frame.height - height
        
        /*
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            
            self.frame = CGRect(x: 0, y: viewY, width: self.frame.width, height: self.frame.height)
            
        }, completion: nil)
        */

        
        
        configureTableView()
        //blurTableView()
    }
    
    func configureGestureRecognizers() {
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeUp.direction = .up
        swipeUp.delegate = self
        addGestureRecognizer(swipeUp)
        mySwipeUp = swipeUp
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeDown.direction = .down
        swipeDown.delegate = self
        addGestureRecognizer(swipeDown)
        mySwipeDown = swipeDown
    }
    
    func configureTableView() {
        
        tableView = UITableView()
        tableView.rowHeight = 300
        //tableView.rowHeight = 220
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = true
        // tableView.layer.cornerRadius = 10
        tableView.separatorColor = .none
        //tableView.backgroundColor = UIColor.rgb(red: 181, green: 201, blue: 215)
        tableView.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 250)
                
        // disables the scrolling feature for the table view
        tableView.isScrollEnabled = false
        
        tableView.register(StoreCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // gives you space on specific sides of the view
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        addSubview(tableView)
        tableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 16, paddingRight: 0, width: 0, height: 0)
        
        /*
        addSubview(indicatorView)
        indicatorView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: -13, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 5)
        indicatorView.centerX(inView: self)
        */
        
        //indicatorView.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        //indicatorView.layer.borderWidth = 1
        
        addSubview(backgroundCancelViewBtn)
        backgroundCancelViewBtn.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 35, height: 35)
        
        backgroundCancelViewBtn.addSubview(cancelViewButton)
        cancelViewButton.anchor(top: backgroundCancelViewBtn.topAnchor, left: nil, bottom: nil, right: backgroundCancelViewBtn.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 15, height: 15)
        
    }
    
    // this is a function that will definitely need to be implemented later
    func disableViewInteraction(directionsEnabled: Bool) {
        self.directionsEnabled = directionsEnabled
        
        if directionsEnabled {
            tableView.allowsSelection = false
            searchBar.isUserInteractionEnabled = false
        } else {
            tableView.allowsSelection = true
            searchBar.isUserInteractionEnabled = true
        }
    }
    
    func presentIntialStoreView() {
        /*
        animateInputView(targetPosition: self.frame.origin.y - 450) { (_) in
            self.expansionState = .PartiallyExpanded
            print("not expanded expanded to partially expanded")
        }
        */
        print("THIS INITIAL STORE VIEW IS BEING SUMMONED")
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.frame.origin.y =  self.frame.origin.y - 380   //450
            
            /*
            self.addSubview(self.indicatorView)
            self.indicatorView.anchor(top: self.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: -13, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 60, height: 7)
            self.indicatorView.centerX(inView: self)
            */
            
            
            //self.indicatorView.frame.origin.y = self.frame.origin.y - 450
        })
    }
    
    @objc func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        
        if directionsEnabled {
            print("Swiping disabled..")
            return
        }
        
        if sender.direction == .up {
            
             print("do nothing")
           /*
           
            
            
            if expansionState == .SubPartiallyExpanded {

                animateInputView(targetPosition: self.frame.origin.y - 180) { (_) in
                    self.expansionState = .PartiallyExpanded
                    print("sub partially expanded to partially expanded")
                    
                }
            }
            
            
            
            
            if expansionState == .PartiallyExpanded {
                /*
                UIView.animate(withDuration: 0.25, animations: {
                    self.homeVC?.storeDetailBV.backgroundColor = UIColor(white: 0, alpha: 0.5)
                    self.homeVC?.storeDetailBV.alpha = 1
                })
                */
                
                self.homeVC?.configureStoreDetailBV()
                
                animateInputView(targetPosition: self.frame.origin.y - 350) { (_) in
                    self.expansionState = .FullyExpanded
                    print("partially expanded to fully expanded")
                }
            }
            */
        } else {
            
          
            if expansionState == .FullyExpanded {
                
                self.homeVC?.handleDismissStoreBV()
                
                animateInputView(targetPosition: self.frame.origin.y + 380) { (_) in
                    self.expansionState = .NotExpanded
                    self.isHidden = true
                    print("fully expanded to not expanded")
                }
                self.homeVC?.storeViewSetToDismissed()
            }
        
        /*
            // this is the swipe down segment
            
            if expansionState == .PartiallyExpanded {

                animateInputView(targetPosition: self.frame.origin.y + 180) { (_) in
                    self.expansionState = .SubPartiallyExpanded
                    print("partially expanded tp sub partially expanded")
                    
                }
            }
            
            if expansionState == .SubPartiallyExpanded {
                
                animateInputView(targetPosition: self.frame.origin.y + 120) { (_) in
                    self.expansionState = .NotExpanded
                    print("partially expanded to not expanded")
                    self.isHidden = true
                    //self.homeVC?.storeViewSetToDismissed()
                }
                self.homeVC?.storeViewSetToDismissed()
            }
          */
        }
        
            
    }

    func dismissDetailView() {
        
        //self.isHidden = true
        
        
        if expansionState == .FullyExpanded {
                
            self.homeVC?.handleDismissStoreBV()
            animateInputView(targetPosition: self.frame.origin.y + 380) { (_) in
                self.expansionState = .NotExpanded
                print("fully expanded to partially expanded")
                
                UIView.animate(withDuration: 0.25, animations:  {
                    self.cancelViewButton.alpha = 1
        
                    self.isHidden = true
                })
                self.homeVC?.isStoreDetailViewVisible = false
            }
        }
        
        /*
        if expansionState == .PartiallyExpanded {
            

            animateInputView(targetPosition: self.frame.origin.y + 300) { (_) in
                self.expansionState = .NotExpanded
                print("partially expanded to not expanded")
                UIView.animate(withDuration: 0.25, animations:  {
                    self.cancelViewButton.alpha = 1
                    self.isHidden = true
                    
                })
                self.homeVC?.isStoreDetailViewVisible = false
            }

        }
        

        if expansionState == .SubPartiallyExpanded {

            homeVC?.showTabBar()
            animateInputView(targetPosition: self.frame.origin.y + 120) { (_) in
                self.expansionState = .NotExpanded
                print("Not expanded to not expanded")
                self.isHidden = true
            }
        }
         */
        homeVC?.storeViewSetToDismissed()
        
        //homeVC?.tabBarController?.tabBar.isHidden = true
    
    }
    
    
    
    /*
    func restoreStoreDetailView() {
        
        print("DEBUG: The restore detail view has been called")
        
            animateInputView(targetPosition: self.frame.origin.y - 300) { (_) in
                self.expansionState = .PartiallyExpanded
                print("DEBUG: view was restored from unseen to partially expanded")
                
                self.cancelViewButton.alpha = 1
                
            }
 
        
        /*
   
         UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3 , options: .curveEaseInOut, animations: {
         
         self.storeDetailView.frame = CGRect(x: 0, y: storeDetailViewY, width: self.storeDetailView.frame.width, height: self.storeDetailView.frame.height)
         }, completion: nil)
 */
       
        
    }
    
    func showStoreDetailView() {
        print("this view did load was called")
        //self.isHidden = false
    }
    */

    @objc func handleDismissView() {
        dismissDetailView()
        
    }

}

// MARK: - UITableViewDataSource/Delegate

extension StoreDetailView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! StoreCell

        if let controller = homeVC {
        cell.delegate = controller
        }
        
        if let selectedAnnotationResults = selectedAnnotationResults {
        cell.mapItem = selectedAnnotationResults[indexPath.row]
        //print(cell.mapItem as Any)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedAnnotationResults = selectedAnnotationResults else { return 0 }
        return selectedAnnotationResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedAnnotationResults = selectedAnnotationResults else { return }
        let selectedMapItem = selectedAnnotationResults[indexPath.row]
        
        
        
        print("this is a test \(selectedMapItem.name)" as Any)
        
        //let firstIndexPath = IndexPath(row: 0, section: 0)
        //let cell = tableView.cellForRow(at: firstIndexPath) as! StoreCell
        //cell.animateButtonIn()
    }
}

extension StoreDetailView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let swipeGesture = gestureRecognizer as? UISwipeGestureRecognizer
            
        if swipeGesture?.direction == .up {
                
                // identify gesture recognizer and return true instead of false
                return gestureRecognizer.isEqual(self.mySwipeUp) ? true : false
                
            } else {
                
                return gestureRecognizer.isEqual(self.mySwipeDown) ? true : false
            }
        }
}


