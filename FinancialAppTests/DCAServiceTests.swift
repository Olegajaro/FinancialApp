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
    
    // test cases
    // 1. asset = winning | dca = true => positive gains
    // 2. asset = winning | dca = false => positive gains
    // 3. asset = losing | dca = true => negative gains
    // 4. asset = losing | dca = false => negative gains
    
    // Format for test function name
    // what
    // given
    // expectation
    
    // Dollar Cost Averaging - DCA
    func testResult_givenWinningAssetAndDCAIsUsed_expectPositiveGains() {
        // given
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 1000
        let initialDateOfInvestmentIndex = 5 // (6 months ago)
        let asset = buildWinningAsset()
        // when
        let result = sut.calculate(
            asset: asset,
            initialInvestmentAmount: initialInvestmentAmount,
            monthlyDollarCostAveragingAmount: monthlyDollarCostAveragingAmount,
            InitialDateOfInvestmentIndex: initialDateOfInvestmentIndex
        )
        // then
        // initial investment: $5000
        // DCA: $1000 * 5 = $5000
        // total: $5000 + $5000 = $10000
        XCTAssertEqual(result.investmentAmount,
                       10000,
                       "investment amount is incorrect")
    }
    
    func testResult_givenWinningAssetAndDCAIsNotUsed_expectPositiveGains() {
        
    }
    
    func testResult_givenLosingAssetAndDCAIsUsed_expectNegativeGains() {
        
    }
    
    func testResult_givenLosingAssetAndDCAIsNotUsed_expectNegativeGains() {
        
    }
    
    private func buildWinningAsset() -> Asset {
        let searchResult = buildSearchResult()
        let metaData = buildMetaData()
        let timeSeries: [String: OHLC] = [
            "2021-01-25": OHLC(open: "100", close: "0", adjustedClose: "110"),
            "2021-02-25": OHLC(open: "110", close: "0", adjustedClose: "120"),
            "2021-03-25": OHLC(open: "120", close: "0", adjustedClose: "130"),
            "2021-04-25": OHLC(open: "130", close: "0", adjustedClose: "140"),
            "2021-05-25": OHLC(open: "140", close: "0", adjustedClose: "150"),
            "2021-06-25": OHLC(open: "150", close: "0", adjustedClose: "160"),
        ]
        let timeSeriesMonthlyAdjusted = TimeSeriesMonthlyAdjusted(
            metaData: metaData,
            timeSeries: timeSeries)
        
        return Asset(
            searchResult: searchResult,
            timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted
        )
    }
    
    private func buildSearchResult() -> SearchResult {
        return SearchResult(symbol: "foo",
                            name: "bar company",
                            type: "BAZ",
                            currency: "USD")
    }
    
    private func buildMetaData() -> MetaData {
        return MetaData(symbol: "foo")
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
