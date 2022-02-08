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
        XCTAssertTrue(result.isProfitable)
        
        // Jan: $5000 / 100 = 50 shares
        // Feb: $1000 / 110 = 9.091 shares
        // Mar: $1000 / 120 = 8.333 shares
        // April: $1000 / 130 = 7.692 shares
        // May: $1000 / 140 = 7.143 shares
        // June $1000 / 150 = 6.666 shares
        // Total shares = 88.925 shares
        // Total current value = 88.925 * $160 (latest month closing price) = $14,228.172
        XCTAssertEqual(result.currentValue, 14228.172, accuracy: 0.1)
        
        // gain = $14,228.172 - $10,000 = $4,228.172
        XCTAssertEqual(result.gain, 4228.172, accuracy: 0.1)
        
        // yeild = $4,228.172 / $10000 = 0.423
        XCTAssertEqual(result.yield, 0.423, accuracy: 0.001)
    }
    
    func testResult_givenWinningAssetAndDCAIsNotUsed_expectPositiveGains() {
        // given
        let initialInvestmentAmount: Double = 5000
        let monthlyDollarCostAveragingAmount: Double = 0
        let initialDateOfInvestmentIndex = 3 // (4 months ago)
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
        // DCA: $0.0 * 5 = $0.0
        // total: $5000 + $0.0 = $5000
        XCTAssertEqual(result.investmentAmount,
                       5000,
                       "investment amount is incorrect")
        XCTAssertTrue(result.isProfitable)
        
        // Mar: $5000 / 120 = 41.6666 shares
        // April: $0 / 130 = 0
        // May: $0 / 140 = 0
        // June $0 / 150 = 0
        // Total shares = 41.6666
        // Total current value = 41.6666 * $160 (latest month closing price) = $6,666.666
        XCTAssertEqual(result.currentValue, 6666.666, accuracy: 0.001)
        
        // gain = $6,666.666 - $5,000 = $1,666.666
        XCTAssertEqual(result.gain, 1666.666, accuracy: 0.001)
        
        // yeild = $1,666.666 / $5000 = 0.3333
        XCTAssertEqual(result.yield, 0.3333, accuracy: 0.0001)
    }
    
    func testResult_givenLosingAssetAndDCAIsUsed_expectNegativeGains() {
        
    }
    
    func testResult_givenLosingAssetAndDCAIsNotUsed_expectNegativeGains() {
        
    }
    
    private func buildWinningAsset() -> Asset {
        let searchResult = buildSearchResult()
        let metaData = buildMetaData()
        let timeSeries: [String: OHLC] = [
            "2021-01-25": OHLC(open: "100", close: "110", adjustedClose: "110"),
            "2021-02-25": OHLC(open: "110", close: "120", adjustedClose: "120"),
            "2021-03-25": OHLC(open: "120", close: "130", adjustedClose: "130"),
            "2021-04-25": OHLC(open: "130", close: "140", adjustedClose: "140"),
            "2021-05-25": OHLC(open: "140", close: "150", adjustedClose: "150"),
            "2021-06-25": OHLC(open: "150", close: "160", adjustedClose: "160"),
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
