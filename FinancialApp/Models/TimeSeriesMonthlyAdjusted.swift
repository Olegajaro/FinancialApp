//
//  TimeSeriesMonthlyAdjusted.swift
//  FinancialApp
//
//  Created by Олег Федоров on 29.01.2022.
//

import Foundation

struct TimeSeriesMonthlyAdjusted: Decodable {
    
    let metaData: MetaData
    let timeSeries: [String: OHLC]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Monthly Adjusted Time Series"
    }
}

struct MetaData: Decodable {
    
    let symbol: String
    
    enum CodingKeys: String, CodingKey {
        case symbol = "2. Symbol"
    }
}

struct OHLC: Decodable {
    
    let open: String
    let close: String
    let adjustedClose: String
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case close = "4. close"
        case adjustedClose = "5. adjusted close"
    }
}
