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
    
    enum APIServiceError: Error {
        case encoding
        case badRequest
    }
    
    var API_KEY: String {
        return keys.randomElement() ?? ""
    }
    
    let keys = ["7VGD3H8O5XWSG1ZY", "ZWS5OSAEJU05SSO2", "XQUMS88NBIJEPZIR"]
    
    func fetchSymbolsPublishser(keywords: String) -> AnyPublisher<SearchResults, Error> {
        
        guard
            let keywords = keywords.addingPercentEncoding(
                withAllowedCharacters: .urlHostAllowed
            )
        else {
            return Fail(error: APIServiceError.encoding).eraseToAnyPublisher()
        }
        
        let urlString =
        "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: APIServiceError.badRequest).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
