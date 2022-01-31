//
//  DateSelectionTableViewController.swift
//  FinancialApp
//
//  Created by Олег Федоров on 31.01.2022.
//

import UIKit

class DateSelectionTableViewController: UITableViewController {
    
    var timeSeriesMonthlyAdjusted: TimeSeriesMonthlyAdjusted?
    var monthInfos: [MonthInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
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
        let monthInfo = monthInfos[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cellID",
            for: indexPath
        ) as! DateSelectionTableViewCell
        
        cell.configure(with: monthInfo)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class DateSelectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var monthsAgoLabel: UILabel!
    
    func configure(with monthInfo: MonthInfo) {
        backgroundColor = .red
    }
}
