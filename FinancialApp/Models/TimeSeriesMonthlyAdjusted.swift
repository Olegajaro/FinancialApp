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
        sortedTimeSeries.forEach { (dateString, ohlc) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: dateString)
            let adjustedOpen = getAdjustedOpen(ohlc: ohlc)
            
            let monthInfo = MonthInfo(
                date: date ?? Date(),
                adjustedOpen: adjustedOpen,
                adjustedClose: Double(ohlc.adjustedClose) ?? 0
            )
            
            monthInfos.append(monthInfo)
        }
        
        return monthInfos
    }
    
    private func getAdjustedOpen(ohlc: OHLC) -> Double {
        // adjustedOpen = open * (adjusted close / close) 
        guard
            let open = Double(ohlc.open),
            let adjustedClose = Double(ohlc.adjustedClose),
            let close = Double(ohlc.close)
        else { return 0 }
        
        return open * (adjustedClose / close)
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
