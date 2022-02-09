//
//  SearchTableViewController.swift
//  FinancialApp
//
//  Created by Олег Федоров on 28.01.2022.
//

import UIKit
import Combine
import MBProgressHUD

class SearchTableViewController: UITableViewController, UIAnimatable {
    
    private enum Mode {
        case onboarding
        case searchMode
    }
    
    // MARK: - Propeties
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
    private var searchResults: SearchResults?
    
    // MARK: - Observable Properties
    @Published private var mode: Mode = .onboarding
    @Published private var searchQuery = String()
    private var subscribers = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        observeForm()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalculator",
           let destination = segue.destination as? CalculatorTableViewController,
           let asset = sender as? Asset {
            
            destination.asset = asset
        }
    }
    
    // MARK: - SetupViews
    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
    }
    
    private func setupTableView() {
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
    }
}

// MARK: - Combine methods
extension SearchTableViewController {
    
    private func observeForm() {
        // tracking the text value from the searchController to pass it to the performSearch method
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] searchQuery in
                performSearch(keywords: searchQuery)
            }.store(in: &subscribers)
        
        // keeping track of the mode state when the state of the searchController changes
        $mode.sink { [unowned self] mode in
            switch mode {
            case .onboarding:
                self.tableView.backgroundView = SearchPlaceholderView()
            case .searchMode:
                self.tableView.backgroundView = nil
            }
        }.store(in: &subscribers)
    }
    
    // getting a list of companies by keywords
    private func performSearch(keywords: String) {
        guard !searchQuery.isEmpty else { return }
        showLoadingAnimation()
    
        apiService.fetchSymbolsPublishser(keywords: keywords)
            .sink { [weak self] completion in
            self?.hideLoadingAnimation()
            
            switch completion {
            case .failure(let error): print(error.localizedDescription)
            case .finished: break
            }
        } receiveValue: { [weak self] searchResults in
            guard let self = self else { return }
            
            self.searchResults = searchResults
            self.tableView.reloadData()
            self.tableView.isScrollEnabled = true
        }.store(in: &subscribers)
    }
    
    // Getting company stock data to pass it to CalculatorTableViewController
    private func handleSelection(for symbol: String,
                                 searchResult: SearchResult) {
        showLoadingAnimation()
        
        apiService.fetchTimeSeriesMonthlyAdjustedPublisher(keywords: symbol)
            .sink { [weak self] completionResult in
                self?.hideLoadingAnimation()
                
                switch completionResult {
                case .failure(let error): print(error)
                case .finished: break
                }
            } receiveValue: { [weak self] timeSeriesMonthlyAdjusted in
                self?.hideLoadingAnimation()
                let asset = Asset(
                    searchResult: searchResult,
                    timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted
                )
                self?.performSegue(withIdentifier: "showCalculator",
                                   sender: asset)
                self?.searchController.searchBar.text = nil
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

// MARK: - UITableViewDelegate
extension SearchTableViewController {
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true )
    
        if let searchResults = self.searchResults {
            let searchResult = searchResults.items[indexPath.row]
            let symbol = searchResult.symbol
            handleSelection(for: symbol, searchResult: searchResult)
        }
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
}

// MARK: - UISearchControllerDelegate
extension SearchTableViewController: UISearchControllerDelegate {}
