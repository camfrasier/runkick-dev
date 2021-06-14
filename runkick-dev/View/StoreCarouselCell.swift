//
//  StoreCarouselCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/8/21.
//  Copyright © 2021 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

class StoreCarouselCell: UICollectionViewCell {
    
    
    var favorite: Store? {
        didSet {
            guard let favoritesImageUrl = favorite?.imageUrl else { return }
            storeImageView.loadImage(with: favoritesImageUrl)
            
            guard let storeName = favorite?.title else { return }
            
            self.titleLabel.text = storeName
        }
    }

    
    let storeImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.lightGray
        return iv
    } ()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Restaurant"
        label.textColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        //label.font = UIFont(name: "ArialRoundedMTBold", size: 16)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewComponents()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        
    // round edges in cell
    self.layer.cornerRadius = 0
    
    // matches the imageview boundary radius to cell for a rounded view
    self.clipsToBounds = true
        
        backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        
        // items here should be more geared towards the user and their daily performance.
        
        // organize by top daily leaders or group leaders - maybe have their cells with their face and stats beneath with all else below
        
        addSubview(storeImageView)
        let groupDiminsions: CGFloat = 70
        storeImageView.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: groupDiminsions, height: groupDiminsions)
        //profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        storeImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        storeImageView.layer.cornerRadius = groupDiminsions / 2
        
        addSubview(titleLabel)
        titleLabel.anchor(top: storeImageView.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        titleLabel.centerXAnchor.constraint(equalTo: storeImageView.centerXAnchor).isActive = true
        
    }
    
    // MARK: - Selectors
    
}
