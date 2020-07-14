//
//  MenuOptionCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 12/4/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import UIKit

class MenuOptionCell: UITableViewCell {

    // MARK: - Properties
    
    let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let iconImageView2: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        //label.textColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        //label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        label.font = UIFont(name: "PingFangTC-Regular", size: 20)
        label.text = "Sample Text"
        return label
        
        //PingFangTC-Medium
        //PingFangTC-Semibold
        //PingFangTC-Regular
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .default
        
        backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        //backgroundColor = UIColor.rgb(red: 181, green: 201, blue: 215)
        
        /*
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 150).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        */
        
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 180).isActive = true
        
        /*
        addSubview(iconImageView2)
        iconImageView2.translatesAutoresizingMaskIntoConstraints = false
        iconImageView2.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView2.leftAnchor.constraint(equalTo: leftAnchor, constant: 380).isActive = true
        iconImageView2.heightAnchor.constraint(equalToConstant: 15).isActive = true
        iconImageView2.widthAnchor.constraint(equalToConstant: 15).isActive = true
        */
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Handlers
    
}
