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
        initialInvestmentAmount: Double,
        monthlyDollarCostAveragingAmount: Double,
        InitialDateOfInvestmentIndex: Int
    ) -> DCAResult {
        
        let investmentAmount = getInvestmentAmount(
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            initialDateOfInvestmentIndex: InitialDateOfInvestmentIndex
        )
        
        return .init(currentValue: 0,
                     investmentAmount: investmentAmount,
                     gain: 0,
                     yield: 0,
                     annualReturn: 0)
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
