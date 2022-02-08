//
//  CalculatorPresenterTests.swift
//  FinancialAppTests
//
//  Created by Олег Федоров on 08.02.2022.
//

import XCTest
@testable import FinancialApp

class CalculatorPresenterTests: XCTestCase {
    
    var sut: CalculatorPresenter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = CalculatorPresenter()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }
    
    // test
    // given
    // expect
    
    func testAnnualReturnLabelTextColor_givenResultIsProfitable_expectSystemGreen() {
        // given
        let result = DCAResult(
            currentValue: 0, investmentAmount: 0,
            gain: 0, yield: 0,
            annualReturn: 0, isProfitable: true
        )
        // when
        let presentation = sut.getPresentation(result: result)
        // then
        XCTAssertEqual(presentation.annualReturnLabelTextColor, .systemGreen)
    }
    
    func testYieldLabelTextColor_givenResultIsProfitable_expectSystemGreen() {
        // given
        let result = DCAResult(
            currentValue: 0, investmentAmount: 0,
            gain: 0, yield: 0,
            annualReturn: 0, isProfitable: true
        )
        // when
        let presentation = sut.getPresentation(result: result)
        // then
        XCTAssertEqual(presentation.yieldLabelTextColor, .systemGreen)
    }
    
    func testAnnualReturnLabelTextColor_givenResultIsNotProfitable_expectSystemRed() {
        // given
        let result = DCAResult(
            currentValue: 0, investmentAmount: 0,
            gain: 0, yield: 0,
            annualReturn: 0, isProfitable: false
        )
        // when
        let presentation = sut.getPresentation(result: result)
        // then
        XCTAssertEqual(presentation.annualReturnLabelTextColor, .systemRed)
    }
    
    func testYieldLabelTextColor_givenResultIsNotProfitable_expectSystemRed() {
        // given
        let result = DCAResult(
            currentValue: 0, investmentAmount: 0,
            gain: 0, yield: 0,
            annualReturn: 0, isProfitable: false
        )
        // when
        let presentation = sut.getPresentation(result: result)
        // then
        XCTAssertEqual(presentation.yieldLabelTextColor, .systemRed)
    }
    
    func testYeildLabel_expectBrackets() {
        // given
        let openBracket: Character = "("
        let closeBracket: Character = ")"
        let result = DCAResult(
            currentValue: 0, investmentAmount: 0,
            gain: 0, yield: 0.25,
            annualReturn: 0, isProfitable: false
        )
        // when
        let presentation = sut.getPresentation(result: result)
        // then
        XCTAssertEqual(presentation.yield.first, openBracket)
        XCTAssertEqual(presentation.yield.last, closeBracket)
    }
}
