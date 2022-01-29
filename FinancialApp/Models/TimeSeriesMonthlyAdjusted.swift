//
//  TimeSeriesMonthlyAdjusted.swift
//  FinancialApp
//
//  Created by Олег Федоров on 29.01.2022.
//

import Foundation

struct MonthInfo {
    let date: Date
    let adjustedOpen: Double
    let adjustedClose: Double
}

struct TimeSeriesMonthlyAdjusted: Decodable {
    
    let metaData: MetaData
    let timeSeries: [String: OHLC]
    
    enum CodingKeys: String, CodingKey {
        case metaData = "Meta Data"
        case timeSeries = "Monthly Adjusted Time Series"
    }
    
    func getMonthInfos() -> [MonthInfo] {
        
        var monthInfos: [MonthInfo] = []
        
        let sortedTimeSeries = timeSeries.sorted { $0.key > $1.key }
        print("sorted: \(sortedTimeSeries)")

        
        return monthInfos
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
