//
//  DCAService.swift
//  FinancialApp
//
//  Created by Олег Федоров on 01.02.2022.
//

import Foundation

// Dollar Cost Averaging
struct DCAService {
    
    func calculate(
        asset: Asset,
        initialInvestmentAmount: Double,
        monthlyDollarCostAveragingAmount: Double,
        InitialDateOfInvestmentIndex: Int
    ) -> DCAResult {
        
        let latestSharePrice = getLatestsSharePrice(asset: asset)
        
        let currentValue = getCurrentValue(
            numberOfShares: 2,
            latestSharePrice: latestSharePrice
        )
        
        let investmentAmount = getInvestmentAmount(
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateOfInvestmentIndex: InitialDateOfInvestmentIndex
        )
        
        return .init(currentValue: currentValue,
                     investmentAmount: investmentAmount,
                     gain: 0,
                     yield: 0,
                     annualReturn: 0)
    }
    
    // currentValue = numberOfShares (inital + DCA) * latest share price
    private func getCurrentValue(
        numberOfShares: Double,
        latestSharePrice: Double
    ) -> Double {
        numberOfShares * latestSharePrice
    }
    
    private func getLatestsSharePrice(asset: Asset) -> Double {
        return asset.timeSeriesMonthlyAdjusted.getMonthInfos().first?.adjustedClose ?? 0
    }
    
    private func getInvestmentAmount(
        initialInvestmentAmount: Double,
        monthlyDollarCostAveragingAmount: Double,
        initialDateOfInvestmentIndex: Int
    ) -> Double {
        var totalAmount = 0.0
        totalAmount += initialInvestmentAmount
        let dollarCostAveragingAmount = initialDateOfInvestmentIndex.doubleValue * monthlyDollarCostAveragingAmount
        totalAmount += dollarCostAveragingAmount
        return totalAmount
    }
}

struct DCAResult {
    let currentValue: Double
    let investmentAmount: Double
    let gain: Double
    let yield: Double
    let annualReturn: Double
}
