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
    @Published private var searchQuery = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        observeForm()
    }
    
    private func observeForm() {
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] searchQuery in
                performSearch(keywords: searchQuery)
            }.store(in: &subscribers)
    }
    
    private func performSearch(keywords: String) {
        apiService.fetchSymbolsPublishser(keywords: keywords).sink { completion in
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
        guard
            let searchQuery = searchController.searchBar.text,
            !searchQuery.isEmpty
        else { return }
        
        self.searchQuery = searchQuery
    }
}

// MARK: - UISearchControllerDelegate
extension SearchTableViewController: UISearchControllerDelegate {
    
}
