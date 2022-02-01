//
//  Double+Extensions.swift
//  FinancialApp
//
//  Created by Олег Федоров on 01.02.2022.
//

import Foundation

extension Double {
    
    var stringValue: String {
        return String(describing: self)
    }
    
    var twoDecimalPlaceString: String {
        return String(format: "%.2f", self)
    }
    
    var currencyFormat: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en-US")
        formatter.numberStyle = .currency
        
        return formatter.string(from: self as NSNumber) ?? twoDecimalPlaceString
    }
}
