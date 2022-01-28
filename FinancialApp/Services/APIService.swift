//
//  APIService.swift
//  FinancialApp
//
//  Created by Олег Федоров on 28.01.2022.
//

import Foundation
import Combine


enum NetworkError: Error {
    case urlError
}

struct APIService {
    
    var API_KEY: String {
        return keys.randomElement() ?? ""
    }
    
    let keys = ["7VGD3H8O5XWSG1ZY", "ZWS5OSAEJU05SSO2", "XQUMS88NBIJEPZIR"]
    
    func fetchSymbolsPublishser(keywords: String) -> AnyPublisher<SearchResults, Error> {
        
        let urlString =
        "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
        
        let url = URL(string: urlString)!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
