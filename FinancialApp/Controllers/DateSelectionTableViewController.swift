//
//  DateSelectionTableViewController.swift
//  FinancialApp
//
//  Created by Олег Федоров on 31.01.2022.
//

import UIKit

class DateSelectionTableViewController: UITableViewController {
    
    var timeSeriesMonthlyAdjusted: TimeSeriesMonthlyAdjusted?
    private var monthInfos: [MonthInfo] = []
    
    var didSelectDate: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupMonthInfos()
    }
    
    private func setupNavigationBar() {
        title = "Select date "
    }
    
    private func setupMonthInfos() {
        if let monthInfos = timeSeriesMonthlyAdjusted?.getMonthInfos() {
            self.monthInfos = monthInfos
        }
    }
}

extension DateSelectionTableViewController {
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return monthInfos.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cellID",
            for: indexPath
        ) as! DateSelectionTableViewCell
        
        let index = indexPath.row
        let monthInfo = monthInfos[index]
        
        cell.configure(with: monthInfo, index: index)
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        didSelectDate?(indexPath.row)
    }
}

class DateSelectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var monthsAgoLabel: UILabel!
    
    func configure(with monthInfo: MonthInfo, index: Int) {
        monthLabel.text = monthInfo.date.MMYYFormat
        
        if index == 1 {
            monthsAgoLabel.text = "1 month ago"
        } else if index > 1 {
            monthsAgoLabel.text = "\(index) month ago"
        } else {
            monthsAgoLabel.text = "Just invested"
        }
    }
}
