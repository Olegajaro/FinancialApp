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
        
        let numberOfShares = getNumberOfShares(
            asset: asset,
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            InitialDateOfInvestmentIndex: InitialDateOfInvestmentIndex
        )
        let latestSharePrice = getLatestsSharePrice(asset: asset)
        
        let currentValue = getCurrentValue(
            numberOfShares: numberOfShares,
            latestSharePrice: latestSharePrice
        )
        
        let investmentAmount = getInvestmentAmount(
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateOfInvestmentIndex: InitialDateOfInvestmentIndex
        )
        
        let isProfitable = currentValue > investmentAmount
        
        let gain = currentValue - investmentAmount
        
        return .init(currentValue: currentValue,
                     investmentAmount: investmentAmount,
                     gain: gain, 
                     yield: 0,
                     annualReturn: 0,
                     isProfitable: isProfitable)
    }
    
    private func getCurrentValue(
        numberOfShares: Double,
        latestSharePrice: Double
    ) -> Double {
        numberOfShares * latestSharePrice
    }
    
    private func getNumberOfShares(
        asset: Asset,
        initialInvestmentAmount: Double,
        monthlyDollarCostAveragingAmount: Double,
        InitialDateOfInvestmentIndex: Int
    ) -> Double {
        var totalShares = Double()
        
        let initialInvestmentOpenPrice =
        asset.timeSeriesMonthlyAdjusted.getMonthInfos()[InitialDateOfInvestmentIndex].adjustedOpen
        
        let initialInvestmentShares = initialInvestmentAmount / initialInvestmentOpenPrice
        totalShares += initialInvestmentShares
        
        asset.timeSeriesMonthlyAdjusted.getMonthInfos().prefix(InitialDateOfInvestmentIndex).forEach { monthInfo in
            let dcaInvestmentShares = monthlyDollarCostAveragingAmount / monthInfo.adjustedOpen
            totalShares += dcaInvestmentShares
        }
        
        return totalShares
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
    let isProfitable: Bool
}
