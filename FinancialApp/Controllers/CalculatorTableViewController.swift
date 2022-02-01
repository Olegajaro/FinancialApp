//
//  CalculatorTableViewController.swift
//  FinancialApp
//
//  Created by Олег Федоров on 29.01.2022.
//

import Foundation
import UIKit
import Combine

class CalculatorTableViewController: UITableViewController {
    
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var investmentAmountLabel: UILabel!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var annualReturnLabel: UILabel!
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var investmentAmountCurrencyLabel: UILabel!
    
    @IBOutlet weak var initialInvestmentAmountTextField: UITextField!
    @IBOutlet weak var monthlyDollarCostAveragingTextField: UITextField!
    @IBOutlet weak var initialDateOfInvestmentTextField: UITextField!
    
    @IBOutlet weak var dateSlider: UISlider!
    
    var asset: Asset?
    
    @Published private var initialDateOfInvestementIndex: Int?
    @Published private var initialInvestmentAmount: Int?
    @Published private var monthlyDollarCostAveraging: Int?
    
    private var subscribers = Set<AnyCancellable>()
    private let dcaService = DCAService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTextFields()
        setupDateSlider()
        observeForm()
    }
    
    @IBAction func dateSliderDidChange(_ sender: UISlider) {
        initialDateOfInvestementIndex = Int(sender.value)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInitialDate",
           let destination = segue.destination as? DateSelectionTableViewController,
           let timeSeriesMonthlyAdjusted = sender as? TimeSeriesMonthlyAdjusted {
            
            destination.timeSeriesMonthlyAdjusted = timeSeriesMonthlyAdjusted
            destination.selectedIndex = initialDateOfInvestementIndex
            destination.didSelectDate = { [weak self] index in
                self?.handleDateSelection(at: index)
            }
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
    
    private func setupDateSlider() {
        if let count = asset?.timeSeriesMonthlyAdjusted.getMonthInfos().count {
            let dateSliderMaxValue = count - 1
            dateSlider.maximumValue = dateSliderMaxValue.floatValue
        }
    }
    
    private func handleDateSelection(at index: Int) {
        guard
            navigationController?.visibleViewController is DateSelectionTableViewController
        else { return }
        
        navigationController?.popViewController(animated: true)
        
        if let monthInfos = asset?.timeSeriesMonthlyAdjusted.getMonthInfos() {
            initialDateOfInvestementIndex = index
            let monthInfo = monthInfos[index]
            let dateString = monthInfo.date.MMYYFormat
            initialDateOfInvestmentTextField.text = dateString
        }
    }
    
    private func observeForm() {
        $initialDateOfInvestementIndex.sink { [weak self] index in
            guard let index = index else { return }
            self?.dateSlider.value = index.floatValue
            
            if let dateString = self?.asset?.timeSeriesMonthlyAdjusted.getMonthInfos()[index].date.MMYYFormat {
                self?.initialDateOfInvestmentTextField.text = dateString
            }
        }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
               object: initialInvestmentAmountTextField
        ).compactMap { (notification) -> String? in
            var text = ""
            
            if let textField = notification.object as? UITextField {
                text = textField.text ?? ""
            }
            
            return text
        }.sink { [weak self] text in
            self?.initialInvestmentAmount = Int(text) ?? 0
        }.store(in: &subscribers)
        
        NotificationCenter.default.publisher(
            for: UITextField.textDidChangeNotification,
               object: monthlyDollarCostAveragingTextField
        ).compactMap { (notification) -> String? in
            var text = ""
            
            if let textField = notification.object as? UITextField {
                text = textField.text ?? ""
            }
            
            return text
        }.sink { [weak self] text in
            self?.monthlyDollarCostAveraging = Int(text) ?? 0
        }.store(in: &subscribers)
        
        Publishers.CombineLatest3(
            $initialInvestmentAmount,
            $monthlyDollarCostAveraging,
            $initialDateOfInvestementIndex
        ).sink { [weak self]
            initialInvestmentAmount,
            monthlyDollarCostAveraging,
            initialDateOfInvestementIndex  in
            
            guard
                let self = self,
                let asset = self.asset,
                let initialInvestmentAmount = initialInvestmentAmount,
                let monthlyDollarCostAveraging = monthlyDollarCostAveraging,
                let initialDateOfInvestementIndex = initialDateOfInvestementIndex
            else { return }
            
            let result = self.dcaService.calculate(
                asset: asset,
                initialInvestmentAmount: initialInvestmentAmount.doubleValue,
                monthlyDollarCostAveragingAmount: monthlyDollarCostAveraging.doubleValue,
                InitialDateOfInvestmentIndex: initialDateOfInvestementIndex
            )
            
            self.currentValueLabel.backgroundColor = result.isProfitable ? .themeGreenShade : .themeRedShade
            self.currentValueLabel.text = result.currentValue.twoDecimalPlaceString
            self.investmentAmountLabel.text = result.investmentAmount.stringValue
            self.gainLabel.text = result.gain.stringValue
            self.yieldLabel.text = result.yield.stringValue
            self.annualReturnLabel.text = result.annualReturn.stringValue
            
        }.store(in: &subscribers)
        
        /*
         NotificationCenter.default.publisher(
             for: UITextField.textDidChangeNotification,
                object: initialInvestmentAmountTextField
         ).compactMap {
             ( $0.object as? UITextField)?.text
         }.sink { text in
             print("initialInvestmentAmountTextField: \(text)")
         }.store(in: &subscribers)
         */
    }
}

extension CalculatorTableViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == initialDateOfInvestmentTextField {
            performSegue(withIdentifier: "showInitialDate",
                         sender: asset?.timeSeriesMonthlyAdjusted)
            return false
        }
        
        return true
    }
}
