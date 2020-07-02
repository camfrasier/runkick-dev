//
//  Product.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/25/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//


// DONT THINK THIS FUNCTION IS USED. USING THE CATEGORY FUNCTION FOR ITEMS


import Foundation
import Firebase

struct Product {
    
    var caption: String!
    var imageUrl: String!
    var creationDate: Date!
    var id: String!
    var category: String!
    var price: Double!
    var poppPrice: Double!
    var address: String!
    var storeId: String!
    
    init(dict: [String: Any]) {
        
     caption = dict["caption"] as? String ?? ""
        imageUrl = dict["imageUrl"] as? String ?? ""
        creationDate = dict["creationDate"] as? Date ?? Date()
        id = dict["id"] as? String ?? ""
        category = dict["category"] as? String ?? ""
        price = dict["price"] as? Double ?? 0.0
        poppPrice = dict["poppPrice"] as? Double ?? 0.0
        address = dict["address"] as? String ?? ""
        storeId = dict["storeId"] as? String ?? ""
    }
}

// may need to add items to this equitable extension below
extension Product: Equatable {}

func ==(lhs: Product, rhs: Product) -> Bool {
    let areEqual = lhs.id == rhs.id &&
        lhs.price == rhs.price

    return areEqual
}


