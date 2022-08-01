//
//  ApiService.swift
//  ExpenseTracker
//
//  Created by Klaudyna Marciniak on 7/30/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Foundation
import Combine

protocol ExchangeService {
    func fetchCurrencyRate(request: DefaultExchangeService.Request) -> AnyPublisher<DefaultExchangeService.ConversionOutput, Error>
}

enum Currency: String, Codable {
    case USD
    case EUR
}

struct DefaultExchangeService: ExchangeService {
        
    struct ConversionOutput: Codable {
        let amount: Double
        let rate: Double
    }
    
    struct Request: Codable {
        let input: ConversionInput
        
        struct ConversionInput: Codable {
            let to: Currency
            let from: Currency
            let amount: Double
        }
    }

    struct ServiceError: Codable, Error {
        let message: String
    }
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchCurrencyRate(request: Request) -> AnyPublisher<DefaultExchangeService.ConversionOutput, Error> {
        let input = request.input
        let params : [String : Any] = ["amount": input.amount,
                                       "to_currency": input.to.rawValue,
                                       "from_currency": input.from.rawValue]
        
        let json = try? JSONSerialization.data(withJSONObject: params)
        
        var urlRequest = URLRequest(url: URL(string:"https://elementsofdesign.api.stdlib.com/aavia-currency-converter@dev/")!)
        let headers = [
                    "Content-Type": "application/json"
                ]
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = json
        urlRequest.allHTTPHeaderFields = headers
        
        return networkManager.publisher(for: urlRequest)
    }
}
