//
//  SearchTableViewController.swift
//  FinancialApp
//
//  Created by Олег Федоров on 28.01.2022.
//

import UIKit
import Combine

class SearchTableViewController: UITableViewController {
    
    private enum Mode {
        case onboarding
        case searchMode
    }
    
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
    private var searchResults: SearchResults?
    @Published private var mode: Mode = .onboarding
    @Published private var searchQuery = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        observeForm()
    }
    
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
    }
    
    private func observeForm() {
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] searchQuery in
                performSearch(keywords: searchQuery)
            }.store(in: &subscribers)
        
        $mode.sink { [unowned self] mode in
            switch mode {
            case .onboarding:
                self.tableView.backgroundView = SearchPlaceholderView()
            case .searchMode:
                self.tableView.backgroundView = nil
            }
        }.store(in: &subscribers)
    }
    
    private func performSearch(keywords: String) {
        apiService.fetchSymbolsPublishser(keywords: keywords).sink { completion in
            switch completion {
            case .failure(let error): print(error.localizedDescription)
            case .finished: break
            }
        } receiveValue: { [weak self] searchResults in
            guard let self = self else { return }
            
            self.searchResults = searchResults
            self.tableView.reloadData()
        }.store(in: &subscribers)
    }
}

// MARK: - UITableViewDataSource
extension SearchTableViewController {
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return searchResults?.items.count ?? 0
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cellId",
            for: indexPath
        ) as! SearchTableViewCell
        
        if let searchResults = self.searchResults {
            let searchResult = searchResults.items[indexPath.row]
            cell.configure(with: searchResult)
        }
        
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
    
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .searchMode
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        mode = .onboarding
    }
}

// MARK: - UISearchControllerDelegate
extension SearchTableViewController: UISearchControllerDelegate {
    
}
