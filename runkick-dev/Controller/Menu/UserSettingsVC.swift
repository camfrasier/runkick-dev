//
//  UserSettingsVC.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 12/22/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SettingsMenuOptionCell"

class UserSettingsVC: UIViewController {
    // MARK: - Properties
    
    var tableView: UITableView!
    var delegate: SettingsControllerDelegate?
    
    let exitMenuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Exit Menu", for: .normal)
        //button.setTitleColor(.init(red: 9/255, green: 171/255, blue: 231/255, alpha: 1), for: .normal)
        button.setTitleColor(.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleCancelButton), for: .touchUpInside)
        return button
    } ()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 235, green: 235, blue: 240)
        
        configureTableView()
    }
    
    // MARK: - Handlers
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(SettingsMenuOptionCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .white
        tableView.rowHeight = 70
        
        self.tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        tableView.addSubview(exitMenuButton)
        exitMenuButton.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc func handleCancelButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension UserSettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsMenuOptionCell
        
        // the below will allow us to bring back a value based on the option pressed
        let settingsMenuOption = SettingsMenuOption(rawValue: indexPath.row)
        cell.descriptionLabel.text = settingsMenuOption?.description
        cell.iconImageView.image = settingsMenuOption?.image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingsMenuOption = SettingsMenuOption(rawValue: indexPath.row)
        
        dismiss(animated: true, completion: nil)
        delegate?.handleSettingsMenuToggle(shouldDismiss: true, settingsMenuOption: settingsMenuOption!)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

