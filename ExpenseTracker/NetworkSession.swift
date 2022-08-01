//
//  NetworkSession.swift
//  ExpenseTracker
//
//  Created by Klaudyna Marciniak on 7/30/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Combine
import Foundation

protocol NetworkSession: AnyObject {
    func publisher(for request: URLRequest) -> AnyPublisher<Data, Error>
}

final class ApiNetworkSession: NetworkSession {
    func publisher(for request: URLRequest) -> AnyPublisher<Data, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                    let error = try JSONDecoder().decode(DefaultExchangeService.ServiceError.self, from: result.data)
                    throw error
                }
                return result.data
            }
            .eraseToAnyPublisher()
    }
}
