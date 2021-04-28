//
//  MarketplaceCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 2/24/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

class MarketplaceCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // where were connect with our view with from the cell via the controller

    var categoryPost: MarketCategory? {
        didSet {
            guard let imageUrl = categoryPost?.imageUrl else { return }
            
            categoryNameLabel.text = categoryPost?.category
            imageView.loadImage(with: imageUrl)
            // here is where the photo wouldbe established  .. will simply add show the pic and rigure it out.
        }
    }

    let imageView: CustomImageView = {
        let iv = CustomImageView()
        iv.backgroundColor = .groupTableViewBackground
        //iv.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 250)
        //iv.contentMode = .scaleAspectFit
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    
    let blackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.20)
        return view
    }()
    
    
    /*
    let blackView: GradientClearView = {
        let view = GradientClearView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    */
    
    let categoryNameLabel: UILabel = {
        let label = UILabel()
        //label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        //label.font = UIFont(name: "HelveticaNeue", size: 15)
        label.font = UIFont(name: "ArialRoundedMTBold", size: 13)
        //label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Sweet Green"
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        //label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.textColor = UIColor.rgb(red: 110, green: 110, blue: 110)
        label.font = UIFont(name: "HelveticaNeue", size: 11)
        label.text = "This will be a list of items under each category. Vegan, etc."
        label.numberOfLines = 0
        return label
    }()
    
    // you can't add subviews when you have a constant because you are mutating it. this is why this needs to be changed into a lazy var
    lazy var nameContainerView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
        view.backgroundColor = .blue
        
        view.addSubview(categoryNameLabel)
        //categoryNameLabel.center(inView: view) // invoking our extension to center the view
        categoryNameLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 2, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        view.addSubview(descriptionLabel)
        descriptionLabel.anchor(top: categoryNameLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 2, paddingBottom: 5, paddingRight: 2, width: 0, height: 0)
        
        return view
    }()
    
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        configureViewComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViewComponents() {
        // round edges in cell
        self.layer.cornerRadius = 0
        
        // matches the imageview boundary radius to cell for a rounded view
        self.clipsToBounds = true
        
        addSubview(imageView)
        //imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: self.frame.height - 32) // 32 is the space value left over at the bottom of the cell
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0) // 32 is the space value left over at the bottom of the cell
        
        //imageView.addSubview(blackView)
        //blackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //blackView.alpha = 0.50
        
        imageView.addSubview(nameContainerView)
        nameContainerView.anchor(top: nil, left: imageView.leftAnchor, bottom: imageView.bottomAnchor, right: imageView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70) // because we gave the image view 32 units of space above
        nameContainerView.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //nameContainerView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        //nameContainerView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
    }
}

