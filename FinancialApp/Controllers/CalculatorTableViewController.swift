//
//  CalculatorTableViewController.swift
//  FinancialApp
//
//  Created by Олег Федоров on 29.01.2022.
//

import Foundation
import UIKit

class CalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel: UILabel!
    @IBOutlet weak var initialInvestmentAmountTextField: UITextField!
    @IBOutlet weak var monthlyDollarCostAveragingTextField: UITextField!
    @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!
    
    var asset: Asset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTextFields()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInitialDate",
           let destination = segue.destination as? DateSelectionTableViewController,
           let timeSeriesMonthlyAdjusted = sender as? TimeSeriesMonthlyAdjusted {
            
            destination.timeSeriesMonthlyAdjusted = timeSeriesMonthlyAdjusted
        }
    }
    
    private func setupViews() {
        symbolLabel.text = asset?.searchResult.symbol
        nameLabel.text = asset?.searchResult.name
        investmentAmountCurrencyLabel.text = asset?.searchResult.currency
        currencyLabels.forEach { label in
            label.text = asset?.searchResult.currency.addBrackets()
        }
    }
    
    private func setupTextFields() {
        initialInvestmentAmountTextField.addDoneButton()
        monthlyDollarCostAveragingTextField.addDoneButton()
        initialDateOfInvestmentTextField.delegate = self
    } 
}

extension CalculatorTableViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == initialDateOfInvestmentTextField {
            performSegue(withIdentifier: "showInitialDate",
                         sender: asset?.timeSeriesMonthlyAdjusted)
        }
        
        return false
    }
}
