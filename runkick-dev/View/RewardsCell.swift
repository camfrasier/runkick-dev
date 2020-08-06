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
            guard let photoImageUrl = reward?.imageUrl else { return }
            rewardsImageView.loadImage(with: photoImageUrl)
            
            guard let storename = reward?.title else { return }
            self.storeTitleLabel.text = storename
            
            guard let points = reward?.points else { return }
            self.pointsLabel.text = String(points)

        }
    }

    let rewardsImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "userProfileIcon")
        return iv
    } ()
    
    let storeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.rgb(red: 17, green: 20, blue: 20)
        return label
    } ()
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
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
        
        let postImageDimension = CGFloat(55)
        addSubview(rewardsImageView)
        rewardsImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: postImageDimension, height: postImageDimension)
        rewardsImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        rewardsImageView.layer.cornerRadius = postImageDimension / 2
        
        addSubview(storeTitleLabel)
        storeTitleLabel.anchor(top: topAnchor, left: rewardsImageView.rightAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addSubview(pointsLabel)
        pointsLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
