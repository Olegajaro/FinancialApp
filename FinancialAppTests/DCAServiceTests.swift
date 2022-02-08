//
//  DCAServiceTests.swift
//  DCAServiceTests
//
//  Created by Олег Федоров on 04.02.2022.
//

import XCTest
@testable import FinancialApp

class DCAServiceTests: XCTestCase {
    
    // System under tests
    var sut: DCAService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DCAService()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    // Format for test function name
    // what
    // given
    // expectation
    
    // Dollar Cost Averaging - DCA
    func testDCAResult_givenDCAIsUsed_expectResult() {
        
    }
    
    func testDCAResult_givenDCAIsNotUsed_expectResult() {
        
    }
    
    // MARK: - Test getInvestmentAmount method
    func testInvestmentAmount_whenDCAIsUsed_expectResult() {
        // given
        let initialInvestmentAmount = 500.0
        let monthlyDollarCostAveraging = 100.0
        let initialDateOfInvestmentIndex = 4 // (5 months ago)
        // when
        let investmentAmount = sut.getInvestmentAmount(
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveraging,
            initialDateOfInvestmentIndex: initialDateOfInvestmentIndex
        )
        // then
        XCTAssertEqual(investmentAmount, 900)
        
        // initial amount: $500
        // DCA: 4 * $100 = $400
        // total: $400 + $500 = $900
    }
    
    func testInvestmentAmount_whenDCAIsNotUsed_expectResult() {
        // given
        let initialInvestmentAmount = 500.0
        let monthlyDollarCostAveraging = 0.0
        let initialDateOfInvestmentIndex = 4 // (5 months ago)
        // when
        let investmentAmount = sut.getInvestmentAmount(
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveraging,
            initialDateOfInvestmentIndex: initialDateOfInvestmentIndex
        )
        // then
        XCTAssertEqual(investmentAmount, 500)
        
        // initial amount: $500
        // DCA: 4 * $0.0 = $0.0
        // total: $0.0 + $500 = $500
    }
}
