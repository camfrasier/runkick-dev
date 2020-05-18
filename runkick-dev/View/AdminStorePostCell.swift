//
//  AdminStorePostCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 5/2/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel

class AdminStorePostCell: UICollectionViewCell {
    // creating a variable of the type FeedCellDelegate that's optional
    var delegate: AdminStorePostCellDelegate?
    
    var storePost: StorePost? {
        
        didSet {
            
            guard let ownerUid = storePost?.ownerUid else { return }
            guard let imageUrl = storePost?.imageUrl else { return }
            //guard let storeId = storePost?.storeId else { return }
            
            Database.fetchUser(with: ownerUid) { (user) in  // In order to grab the photo of the correct post owner.
                self.configurePostCaption(user: user)
            }
            
            postImageView.loadImage(with: imageUrl)
        }
    }
    
    // MARK: - Properties
    
    let profileImageView: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var captionBlock: UIView = {
        let view = UIView()
        return view
    }()
    
    let captionLabel: ActiveLabel = { // Will replace later with an action label.
        let label = ActiveLabel()
        label.text = "Caption Placeholder"
        label.numberOfLines = 0
        return label
    } ()
    
    let storeIdLabel: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "Store ID"
        label.numberOfLines = 0
        return label
    } ()
    
    let categoryLabel: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    } ()
    
    let priceLabel: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        label.text = "9.00"
        label.numberOfLines = 0
        return label
    } ()
    
    let poppPriceLabel: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "5.00"
        label.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        label.numberOfLines = 0
        return label
    } ()
    
    lazy var optionsButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "optionIconDots")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleOptionTapped), for: .touchUpInside)
        return button
    } ()
    
    lazy var backgroundOptionsButton: UIView = {
        let view = UIView()
        let optionTap = UITapGestureRecognizer(target: self, action: #selector(handleOptionTapped))
        optionTap.numberOfTapsRequired = 1
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(optionTap)
        return view
    }()
    
    lazy var postImageView: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        // add gesture recognizer for double tap to like
        let likeTap = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapped))
        likeTap.numberOfTapsRequired = 2
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(likeTap)
        //iv.layer.cornerRadius = 12
        
        return iv
    } ()

    
    let postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "2 days ago"
        return label
    } ()
    
    let separatorView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        view.backgroundColor = UIColor(red: 188/255, green: 208/255, blue: 214/255, alpha: 1)
        return view
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContraints()
        backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContraints() {
          
        // photo attributes and constraints
        addSubview(postImageView)
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.layer.cornerRadius = 0
        
        addSubview(captionBlock)
        captionBlock.translatesAutoresizingMaskIntoConstraints = false
        captionBlock.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        // caption label attributes and constraints
        captionBlock.addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // store id label attributes and constraints
        addSubview(storeIdLabel)
        storeIdLabel.translatesAutoresizingMaskIntoConstraints = false
        storeIdLabel.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        storeIdLabel.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        // category label attributes and constraints
        addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
        //options background
        addSubview(backgroundOptionsButton)
        backgroundOptionsButton.backgroundColor = .clear
        backgroundOptionsButton.translatesAutoresizingMaskIntoConstraints = false
            
        // option button constraints
        backgroundOptionsButton.addSubview(optionsButton)
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.tintColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
        
        // date and time attributes and constraints
        addSubview(postTimeLabel)
        postTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        postTimeLabel.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        
        // price attributes and constraints
        addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        
        // poppPrice attributes and constraints
        addSubview(poppPriceLabel)
        poppPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        poppPriceLabel.textColor = UIColor(red: 120/255, green: 120/255, blue: 120/255, alpha: 1)
        

        // separator view constraints
        //addSubview(separatorView)
        //separatorView.translatesAutoresizingMaskIntoConstraints = false
        //separatorView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)

    
        // building constraints
          //separatorView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.25)
  
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 400, height: 400)
        
        captionBlock.anchor(top: postImageView.bottomAnchor, left: postImageView.leftAnchor, bottom: nil, right: postImageView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        captionLabel.anchor(top: captionBlock.topAnchor, left: captionBlock.leftAnchor, bottom: captionBlock.bottomAnchor, right: captionBlock.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        storeIdLabel.anchor(top: captionBlock.bottomAnchor, left: captionBlock.leftAnchor, bottom: nil, right: captionBlock.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
          
        categoryLabel.anchor(top: storeIdLabel.bottomAnchor, left: captionBlock.leftAnchor, bottom: nil, right: captionBlock.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        
        backgroundOptionsButton.anchor(top: categoryLabel.bottomAnchor, left: nil, bottom: nil, right: captionBlock.rightAnchor, paddingTop: 14, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 25, height: 25)
        
        optionsButton.anchor(top: backgroundOptionsButton.topAnchor, left: backgroundOptionsButton.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 20, height: 20)
        
        priceLabel.anchor(top: categoryLabel.bottomAnchor, left: captionBlock.leftAnchor, bottom: nil, right: captionBlock.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        
        poppPriceLabel.anchor(top: priceLabel.bottomAnchor, left: captionBlock.leftAnchor, bottom: nil, right: captionBlock.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 0)
        
        postTimeLabel.anchor(top: poppPriceLabel.bottomAnchor, left: captionBlock.leftAnchor, bottom: nil, right: captionBlock.rightAnchor, paddingTop: 4, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
          
        /*
        
        
        
  
        
        
        
        */
        /*
        
        */
      }
    
    @objc func handlePhotoTapped() {
        //delegate?.handleLikeTapped(for: self, isDoubleTap: true)
        delegate?.handlePhotoTapped(for: self)
    }
    
    @objc func handleOptionTapped() {
        delegate?.handleOptionTapped(for: self)
    }

    
    func configurePostCaption(user: User) {
        
        guard let post = self.storePost else { return }
        guard let caption = post.caption else { return }  // Safely unwrap so we don't get this as an optional anymore.
        guard let storeId = post.storeId else { return }
        guard let category = post.category else { return }
        guard let price = post.price else { return }
        guard let poppPrice = post.poppPrice else { return }

        print("DEBUG: CAPTION IS THIS\(caption)")
        // setting max number of lines shown under the caption
        // to adjust the number of characters go to UpoloadPostVC
        captionLabel.customize { (label) in
            label.text = "\(caption)"
            //label.customColor[customType] = .black
            label.font = UIFont.systemFont(ofSize: 18)
            label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
            captionLabel.numberOfLines = 12
            
            print("DEBUG: CAPTION IS THIS\(caption)")
        }
        
        postTimeLabel.text = post.creationDate.timeAgoToDisplay()
        storeIdLabel.text = "Store Id: \(storeId)"
        categoryLabel.text = "Category: \(category)"
        //priceLabel.text = String(format: "%.2f", "Price: $\(price)")
        priceLabel.text = String(format: "%.2f", price)
        poppPriceLabel.text = String(format: "%.2f", poppPrice)
    }
    
    
    
    
}
