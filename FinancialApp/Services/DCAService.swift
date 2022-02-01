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
            initialDateOfInvestmentIndex: InitialDateOfInvestmentIndex
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
        let yield = gain / investmentAmount
        let annualReturn = getAnnualReturn(
            currentValue: currentValue,
            investmentAmount: investmentAmount,
            initialDateOfInvestmentIndex: InitialDateOfInvestmentIndex
        )
        
        return .init(currentValue: currentValue,
                     investmentAmount: investmentAmount,
                     gain: gain, 
                     yield: yield,
                     annualReturn: annualReturn,
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
        initialDateOfInvestmentIndex: Int
    ) -> Double {
        var totalShares = Double()
        
        let initialInvestmentOpenPrice =
        asset.timeSeriesMonthlyAdjusted.getMonthInfos()[initialDateOfInvestmentIndex].adjustedOpen
        
        let initialInvestmentShares = initialInvestmentAmount / initialInvestmentOpenPrice
        totalShares += initialInvestmentShares
        
        asset.timeSeriesMonthlyAdjusted.getMonthInfos().prefix(initialDateOfInvestmentIndex).forEach { monthInfo in
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
    
    private func getAnnualReturn(
        currentValue: Double,
        investmentAmount: Double,
        initialDateOfInvestmentIndex: Int
    ) -> Double {
        let rate = currentValue / investmentAmount
        let years = ((initialDateOfInvestmentIndex + 1) / 12).doubleValue
        return pow(rate, 1 / years) - 1
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
