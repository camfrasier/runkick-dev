//
//  CheckoutCell.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/28/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import UIKit
import Firebase

class CheckoutCell: UITableViewCell {
    
    // Mark: - Properties
    
    var category: Category? {
         didSet {
             guard let imageUrl = category?.imageUrl else { return }
             
            captionLabel.text = category?.caption
            
            guard let price = category?.price else { return }
            guard let poppPrice = category?.poppPrice else { return }
            
            priceLabel.text = convertToCurrency(price)
            poppPriceLabel.text = convertToCurrency(poppPrice)
            
             postImageView.loadImage(with: imageUrl)
             // here is where the photo wouldbe established  .. will simply add show the pic and rigure it out.
         }
     }
    
    private var item: Category!
    weak var delegate: CheckoutCellDelegate?
    
    
    lazy var postImageView: CustomImageView = {  // Using the Custom image view class.
        let iv = CustomImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "userProfileSilhouetteWhite")
        return iv
    } ()

     let captionLabel: UILabel = {
         let label = UILabel()
         label.numberOfLines = 0 // this doesn't wrap text
         label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
         label.font = UIFont.boldSystemFont(ofSize: 15)
         label.text = "Sweet Green"
         return label
     }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "$0.00"
        return label
    }()
    
    let poppPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "$0.00"
        return label
    }()
    // you can't add subviews when you have a constant because you are mutating it. this is why this needs to be changed into a lazy var
    lazy var removeItemButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "redTrashCan"), for: .normal)
        button.addTarget(self, action: #selector(handleRemoveItem), for: .touchUpInside)
        return button
    }()
     
     
     lazy var captionContainerView: UIView = {
         let view = UIView()
        
         //view.backgroundColor = .clear
         return view
     }()
    
    let itemBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 255, green: 255, blue: 255)
        view.layer.shadowOpacity = 95 // Shadow is 30 percent opaque.
        view.layer.shadowColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 0.20).cgColor
        view.layer.shadowRadius = 2.0
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.text = "Checkout Item"
    
        self.selectionStyle = .none
        

    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        configureCellComponents()
   
    }
    
    func configureCell(product: Category, delegate: CheckoutCellDelegate) {
        
        self.delegate = delegate
        self.item = product
        
        guard let imageUrl = product.imageUrl else { return }
                   
        captionLabel.text = product.caption
                  
        guard let price = product.price else { return }
        guard let poppPrice = product.poppPrice else { return }
                  
                  priceLabel.text = convertToCurrency(price)
                  poppPriceLabel.text = convertToCurrency(poppPrice)
                  
                   postImageView.loadImage(with: imageUrl)
        
    }
    
    func configureCellComponents() {
        
        addSubview(itemBackgroundView)
        itemBackgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0)
        
        itemBackgroundView.addSubview(postImageView)
        postImageView.anchor(top: itemBackgroundView.topAnchor, left: itemBackgroundView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
        
        itemBackgroundView.addSubview(captionLabel)
        captionLabel.anchor(top: postImageView.topAnchor, left: postImageView.rightAnchor, bottom: nil, right: itemBackgroundView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 50, width: 200, height: 24)
        captionLabel.backgroundColor = UIColor.rgb(red: 245, green: 245, blue: 245)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        itemBackgroundView.addSubview(priceLabel)
        priceLabel.anchor(top: captionLabel.bottomAnchor, left: captionLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        // if something is true hear either chosoe configure price function or configure popp price
        configurePrice()
        
        itemBackgroundView.addSubview(removeItemButton)
        removeItemButton.anchor(top: nil, left: nil, bottom: nil, right: itemBackgroundView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 22, height: 25)
        removeItemButton.centerYAnchor.constraint(equalTo: postImageView.centerYAnchor).isActive = true
        
        
    }
    
    func configurePrice() {
        
        itemBackgroundView.addSubview(priceLabel)
        priceLabel.anchor(top: captionLabel.bottomAnchor, left: captionLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func configurePoppPrice() {
        
        itemBackgroundView.addSubview(poppPriceLabel)
        poppPriceLabel.anchor(top: captionLabel.bottomAnchor, left: captionLabel.leftAnchor, bottom: nil, right: nil, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    @objc func handleRemoveItem() {
        print("WE AT LEAST GET HERE - handle remove item")
        delegate?.removeItemFromCart(for: self, category: item)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
