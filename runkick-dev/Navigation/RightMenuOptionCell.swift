//
//  RightMenuOptionCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 4/18/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

class RightMenuOptionCell: UITableViewCell {

    // MARK: - Properties

    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let iconImageView2: UIImageView = {
        let iv = UIImageView()
        iv.image = iv.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        //iv.tintColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        iv.tintColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        //label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        label.text = "Sample Text"
        return label
    }()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear

        selectionStyle = .default
        
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 20).isActive = true
        
        
        addSubview(iconImageView2)
        iconImageView2.translatesAutoresizingMaskIntoConstraints = false
        iconImageView2.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView2.rightAnchor.constraint(equalTo: rightAnchor, constant: -45).isActive = true
        iconImageView2.heightAnchor.constraint(equalToConstant: 15).isActive = true
        iconImageView2.widthAnchor.constraint(equalToConstant: 15).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
