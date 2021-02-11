//
//  ScrollViewCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 1/18/21.
//  Copyright © 2021 Cameron Frasier. All rights reserved.
//

import UIKit

class ScrollViewCell: UITableViewCell {
    
    var post: Post? {
        
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            postImageView.loadImage(with: imageUrl)
        }
    }
    
    let postImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
            backgroundColor = UIColor.rgb(red: 255, green: 200, blue: 0)
        
        //addSubview(postImageView)
        //postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        //postImageView.layer.cornerRadius = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

