//
//  StripeCart.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/28/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import Foundation
import Firebase

let StripeCart = _StripeCart()

// service that keeps track of items added to our shopping cart

final class _StripeCart {
    
    var cartItems = [Category]()
    private let stripeCreditCardCut = 0.029 // 2.9%
    private let flatFeeCents = 30 // in cents
    var shippingFees = 0
    
    // variables for subtotal, processing fees, total
    
    var subtotal : Int {
        var amount = 0
        for item in cartItems {
            let pricePennies = Int(item.price * 100)
            amount += pricePennies
        }
        return amount
    }
    
    var processingFees : Int {
        if subtotal == 0 {
            return 0
        }
        
        
        // convert to a double first in order to multiply by 0.029
        let sub = Double(subtotal)
        let feesAndSub = Int(sub * stripeCreditCardCut) + flatFeeCents
        return feesAndSub
    }
    
    var total : Int {
        return subtotal + processingFees + shippingFees
    }
    
    func addItemToCart(item: Category) {
        cartItems.append(item)
    }
    
    func removeItemFromCart(item: Category) {
        if let index = cartItems.firstIndex(of: item) {
            cartItems.remove(at: index)
        }
    }
    
    func clearCart() {
        cartItems.removeAll()
    }
    
    // will need to add another function for the reducing the price for the user when using points
    
}
