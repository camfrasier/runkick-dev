//
//  RewardsCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/3/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit

class RewardsCell: UITableViewCell {
    
    // Mark: - Properties
    var reward: Rewards? {
        didSet {
            //guard let profileImageUrl = rewards?.profileImageURL else { return }
            //profileImageView.loadImage(with: profileImageUrl)
            
            guard let storename = reward?.title else { return }
            self.storeTitleLabel.text = storename
        }
    }

    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "userProfileIcon")
        //iv.layer.borderWidth = 4
        //iv.layer.borderColor = UIColor.lightGray.cgColor
        return iv
    } ()
    
    let storeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.rgb(red: 17, green: 20, blue: 20)
        return label
    } ()
    
    let separatorView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220).cgColor
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        self.storeTitleLabel.text = "Store Name"
    
        //self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        addSubview(storeTitleLabel)
        storeTitleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
