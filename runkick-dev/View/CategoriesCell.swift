//
//  CategoriesCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/14/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

class CategoriesCell: UITableViewCell {
    
    // Mark: - Properties
    
    var categoryPost: MarketCategory? {
        didSet {
            //guard let imageUrl = categoryPost?.imageUrl else { return }
            
            categoryNameLabel.text = categoryPost?.category
            //imageView.loadImage(with: imageUrl)
            // here is where the photo wouldbe established  .. will simply add show the pic and rigure it out.
 
        }
    }
    
    let categoryNameLabel: UILabel = {
        let label = UILabel()
        //label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        //label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Sweet Green"
        return label
    }()

    let separatorView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220).cgColor
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        //self.detailTextLabel?.text = "Full Name"
    
        //self.selectionStyle = .none
        self.categoryNameLabel.text = "Categories"
        
        self.backgroundColor = .white

        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        addSubview(categoryNameLabel)
        categoryNameLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        categoryNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
