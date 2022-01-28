//
//  SearchTableViewController.swift
//  FinancialApp
//
//  Created by Олег Федоров on 28.01.2022.
//

import UIKit
import Combine

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
    
    private let apiService = APIService()
    private var subscribers = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        performSearch()
    }
    
    private func performSearch() {
        
        apiService.fetchSymbolsPublishser(keywords: "S&P500").sink { completion in
            switch completion {
            case .failure(let error): print(error.localizedDescription)
            case .finished: break
            }
        } receiveValue: { searchResults in
            print(searchResults)
        }.store(in: &subscribers)
        
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
    }
}

// MARK: - UITableViewDataSource
extension SearchTableViewController {
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        5
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cellId",
            for: indexPath
        )
         
        return cell
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
