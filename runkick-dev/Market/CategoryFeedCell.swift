//
//  CategoryFeedCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 5/11/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase
import ActiveLabel


class CategoryFeedCell: UICollectionViewCell {

    // creating a variable of the type FeedCellDelegate that's optional
    var delegate: CategoryFeedCellDelegate?
    
    var categoryPost: Category? {
        
        didSet {
            
            guard let imageUrl = categoryPost?.imageUrl else { return }
            guard let caption = categoryPost?.caption else { return }
            guard let postId = categoryPost?.postId else { return }
            
            
            Database.fetchCategoryPosts(with: postId) { (category) in
                
                self.configurePostCaption(category: category)
            }
            
            
            postImageView.loadImage(with: imageUrl)
        }
    }

     // MARK: - Properties
    
    
    lazy var postImageView: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        
        // add gesture recognizer for double tap to like
        let photoTapped = UITapGestureRecognizer(target: self, action: #selector(handlePhotoTapped))
        photoTapped.numberOfTapsRequired = 1
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(photoTapped)
        return iv
    } ()
    
    lazy var captionBlock: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var categoryBlock: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var priceBlock: UIView = {
           let view = UIView()
           return view
       }()
    
    lazy var poppPriceBlock: UIView = {
        let view = UIView()
        return view
    }()
    
    let captionLabel: ActiveLabel = { // Will replace later with an action label.
        let label = ActiveLabel()
        label.numberOfLines = 0
        return label
    } ()
    
    let categoryLabel: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    } ()
    
    let priceLabel: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    } ()
    
    let poppPriceLabel: UILabel = { // Will replace later with an action label.
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    } ()
    
    let postTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "2 days ago"
        return label
    } ()
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureContraints()

        backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
    }
    
    func configureContraints() {
        
        // photo attributes and constraints
        addSubview(postImageView)
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.layer.cornerRadius = 0
        
        postImageView.addSubview(poppPriceBlock)
        poppPriceBlock.translatesAutoresizingMaskIntoConstraints = false
        poppPriceBlock.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        poppPriceBlock.layer.shadowOpacity = 50 // Shadow is 30 percent opaque.
        poppPriceBlock.layer.shadowColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 0.30).cgColor
        poppPriceBlock.layer.shadowRadius = 3.0
        poppPriceBlock.layer.shadowOffset = CGSize(width: 0, height: 1)
        
        poppPriceBlock.addSubview(poppPriceLabel)
        poppPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        poppPriceLabel.textColor = UIColor.rgb(red: 80, green: 80, blue: 80)
        

        addSubview(captionBlock)
        captionBlock.translatesAutoresizingMaskIntoConstraints = false
        captionBlock.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 250)
        
        // caption label attributes and constraints
        captionBlock.addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(categoryBlock)
        categoryBlock.translatesAutoresizingMaskIntoConstraints = false
        categoryBlock.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 250)
           
        // caption label attributes and constraints
        categoryBlock.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        
        addSubview(priceBlock)
        priceBlock.translatesAutoresizingMaskIntoConstraints = false
        priceBlock.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 250)
        
        priceBlock.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.textColor = UIColor.rgb(red: 120, green: 120, blue: 120)
        

        
           
        // vertical constraints

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[caption]-0-|", options: [], metrics: nil, views: ["caption": captionLabel]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[price]-0-|", options: [], metrics: nil, views: ["price": priceLabel]))
        
         self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[poppPrice]-0-|", options: [], metrics: nil, views: ["poppPrice": poppPriceLabel]))
        
        // horizontal constraints

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[category]-0-|", options: [], metrics: nil, views: ["category": categoryLabel]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[price]-0-|", options: [], metrics: nil, views: ["price": priceLabel]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[poppPrice]-0-|", options: [], metrics: nil, views: ["poppPrice": poppPriceLabel]))

        
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 160)
        
        poppPriceBlock.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 25)
           
        captionBlock.anchor(top: postImageView.bottomAnchor, left: postImageView.leftAnchor, bottom: nil, right: postImageView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 20)
        
        categoryBlock.anchor(top: captionBlock.bottomAnchor, left: postImageView.leftAnchor, bottom: nil, right: postImageView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 20)
        
        priceBlock.anchor(top: categoryBlock.bottomAnchor, left: postImageView.leftAnchor, bottom: nil, right: postImageView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 30, width: 0, height: 20)
       }
       
       
       func configurePostCaption(category: Category) {
        
            guard let post = self.categoryPost else { return }
            guard let caption = post.caption else { return }  // Safely unwrap so we don't get this as an optional anymore.
            //guard let storeId = post.storeId else { return }
            guard let category = post.category else { return }
            guard let price = post.price else { return }
            guard let poppPrice = post.poppPrice else { return }
        
            
            // setting max number of lines shown under the caption
            // to adjust the number of characters go to UpoloadPostVC
            captionLabel.customize { (label) in
                label.text = "\(caption)"
                //label.customColor[customType] = .black
                label.font = UIFont.systemFont(ofSize: 16)
                label.textColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1)
                captionLabel.numberOfLines = 2
            }
               
            postTimeLabel.text = post.creationDate.timeAgoToDisplay()
            //storeIdLabel.text = "Store Id: \(storeId)"
            categoryLabel.text = category
            //priceLabel.text = "$\(Int(price))"  // want price to be displayed simple no decimals
            //poppPriceLabel.text = "$\(Int(poppPrice))"
        //priceLabel.text = String(format: "%.2f", price)
        //poppPriceLabel.text = String(format: "%.2f", poppPrice)
        priceLabel.text = convertToCurrency(price)
        poppPriceLabel.text = convertToCurrency(poppPrice)
       }
    
    @objc func handlePhotoTapped() {
        
        print("we get photo tapped")
        delegate?.handlePhotoTapped(for: self)
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
