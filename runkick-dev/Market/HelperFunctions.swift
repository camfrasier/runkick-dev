//
//  HelperFunctions.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 6/20/20.
//  Copyright © 2020 Cameron Frasier. All rights reserved.
//

import Foundation


func convertToCurrency(_ number: Double) -> String {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale(identifier: "es_US")
    //currencyFormatter.locale = Locale.current
    //currencyFormatter.locale = Locale(identifier: "es_ES")
    
    return currencyFormatter.string(from: NSNumber(value: number))!
}
