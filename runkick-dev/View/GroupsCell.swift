//
//  GroupsCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/5/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit

class GroupsCell: UICollectionViewCell {
    
    /*
    var post: Post? {
        
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            postImageView.loadImage(with: imageUrl)
        }
    }
    */
    
    let postImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.image = UIImage(named: "userProfileSilhouetteWhite")
        return iv
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let postImageDimension = CGFloat(90)
        addSubview(postImageView)
        postImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: postImageDimension, height: postImageDimension)
        postImageView.layer.cornerRadius = postImageDimension / 2
        postImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        postImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
