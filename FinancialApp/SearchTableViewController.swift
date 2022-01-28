//
//  SearchTableViewController.swift
//  FinancialApp
//
//  Created by Олег Федоров on 28.01.2022.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Enter a company name or symbol"
        sc.searchBar.autocapitalizationType = .allCharacters
        return sc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
    }
}

// MARK: - UISearchResultsUpdating
extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

// MARK: - UISearchControllerDelegate
extension SearchTableViewController: UISearchControllerDelegate {
    
}
