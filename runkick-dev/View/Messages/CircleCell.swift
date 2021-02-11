//
//  CircleCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 9/7/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit

class CircleCell: UICollectionViewCell {
    
    var logo: Logos? {
        
        didSet {
            guard let logoUrl = logo?.logoUrl else { return }
            storeImageView.loadImage(with: logoUrl)
            
            print("THE POST URL UNDER THE LOGO IMAGES IS THIS \(logoUrl)")
        }
    }
    
    let storeImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "sweetGreenLogo")
        return iv
    } ()
    
    let groupsNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        label.text = "Group Name"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        let storeImageDimension = CGFloat(85)
        addSubview(storeImageView)
        storeImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: storeImageDimension, height: storeImageDimension)
        storeImageView.layer.cornerRadius = storeImageDimension / 2
        //storeImageView.layer.cornerRadius = (storeImageDimension / 2.5)
        
        //storeImageView.layer.borderColor = UIColor.rgb(red: 255, green: 255, blue: 255).cgColor
        //storeImageView.layer.borderWidth = 1
        storeImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        storeImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        
        backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        //addSubview(groupsNameLabel)
        //groupsNameLabel.anchor(top: groupsImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //groupsNameLabel.centerXAnchor.constraint(equalTo: groupsImageView.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
