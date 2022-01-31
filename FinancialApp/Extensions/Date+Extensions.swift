//
//  Date+Extensions.swift
//  FinancialApp
//
//  Created by Олег Федоров on 31.01.2022.
//

import Foundation

extension Date {
    
    var MMYYFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}
