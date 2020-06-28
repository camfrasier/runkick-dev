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
    
    var categoryPost: MarketCategory? {
         didSet {
             guard let imageUrl = categoryPost?.imageUrl else { return }
             
             categoryNameLabel.text = categoryPost?.category
             //imageView.loadImage(with: imageUrl)
             // here is where the photo wouldbe established  .. will simply add show the pic and rigure it out.
         }
     }

     let categoryNameLabel: UILabel = {
         let label = UILabel()
         //label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
         label.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
         label.font = UIFont.boldSystemFont(ofSize: 15)
         label.text = "Sweet Green"
         return label
     }()
     
     // you can't add subviews when you have a constant because you are mutating it. this is why this needs to be changed into a lazy var
     lazy var nameContainerView: UIView = {
         let view = UIView()
         //view.backgroundColor = UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 1)
         view.backgroundColor = .clear
         
         view.addSubview(categoryNameLabel)
         categoryNameLabel.center(inView: view) // invoking our extension to center the view
         
         return view
     }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.text = "Checkout Item"
    
        self.selectionStyle = .none
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        
        textLabel?.frame = CGRect(x: 0, y: textLabel!.frame.origin.y + 2, width: textLabel!.frame.width + 50, height: (textLabel?.frame.height)!)
        textLabel?.font = UIFont.systemFont(ofSize: 16)
        textLabel?.textColor = UIColor.rgb(red: 130, green: 130, blue: 130)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
