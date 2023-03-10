//
//  NewMessageCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/26/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

class NewMessageCell: UITableViewCell {

    // MARK: - Properties
    
    var user: User? {
        
        didSet {
            guard let profileImageUrl = user?.profileImageURL else { return }
            guard let username = user?.username else { return }
            guard let firstname = user?.firstname else { return }
            
            profileImageView.loadImage(with: profileImageUrl)
            textLabel?.text = username
            detailTextLabel?.text = firstname
        }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        let profileImageDimension = CGFloat(55)
        addSubview(profileImageView)
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: profileImageDimension, height: profileImageDimension)
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        textLabel?.text = "Joker"
        detailTextLabel?.text = "Heath Ledger"
    }
    
    // MARK: - Init
    
    override func layoutSubviews() {
        // this needs to be called for the below to actually run
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 68, y: textLabel!.frame.origin.y - 2,
                                  width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        
        detailTextLabel?.frame = CGRect(x: 68, y: detailTextLabel!.frame.origin.y + 2,
                                        width: self.frame.width - 108, height: (detailTextLabel?.frame.height)!)
        detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        detailTextLabel?.textColor = .lightGray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
