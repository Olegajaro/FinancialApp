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
        
        return .init(currentValue: 0,
                     investmentAmount: 0,
                     gain: 0,
                     yield: 0,
                     annualReturn: 0)
    }
}

struct DCAResult {
    let currentValue: Double
    let investmentAmount: Double
    let gain: Double
    let yield: Double
    let annualReturn: Double
}
