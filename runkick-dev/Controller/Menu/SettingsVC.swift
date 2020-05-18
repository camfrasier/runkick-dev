//
//  SettingsVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 10/31/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//



// may not need this view controller all together

import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    var homeVC: HomeVC?
    // AMRK: - Properties
    
    let userLogoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleUserLogout), for: .touchUpInside)
        return button
    }()
    
    let exitSettingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Exit Settings", for: .normal)
        button.setTitleColor(.init(red: 17/255, green: 140/255, blue: 237/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleExitSettings), for: .touchUpInside)
        return button
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponents()

        // Do any additional setup after loading the view.
    }
    
    func configureViewComponents() {
        
        view.backgroundColor = .white
        
        view.addSubview(userLogoutButton)
        userLogoutButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 40, paddingBottom: 200, paddingRight: 0, width: 0, height: 0)
        
        view.addSubview(exitSettingsButton)
        exitSettingsButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func handleUserLogout() {
        
        if Auth.auth().currentUser == nil {
            
            let loginVC = LoginVC()
            present(loginVC, animated: true, completion:nil)
            
        } else {
            // We need a do, try, catch block
            do {
                try Auth.auth().signOut()
                
                print("DEBUG: user logout handled here")
                
            } catch (let error) {
                print(error)
            }
        }
    }
    
    @objc func handleExitSettings() {
        
        dismiss(animated: true, completion: nil)
    }
}


