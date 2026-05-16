//
//  NetworkRatesService.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 26.04.26.
//

import Foundation

// MARK: - Сетевой сервис

final class NetworkRatesService: ExchangeRatesServiceProtocol {

    // MARK: - Singleton
    static let shared = NetworkRatesService()

    // MARK: - Properties
    private let baseURL = "https://belarusbank.by/api"
    private let session: URLSession

    // MARK: Initialization
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true

        session = URLSession(configuration: configuration)
    }

    // MARK: - GCD подход (Completion Handler)

    func fetchRates(completion: @escaping (Result<[ExchangeRatesAPIModel], NetworkError>) -> Void) {

        guard let url = URL(string: "\(baseURL)/kursExchange") else {
            completion(.failure(.invalidURL))
            return
        }

        let task = session.dataTask(with: url) { data, response, error in

            if let error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.noData))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.httpError(statusCode: httpResponse.statusCode)))
                return
            }

            guard let data else {
                completion(.failure(.noData))
                return
            }

            // Decode JSON
            do {
                let decoder = JSONDecoder()
                let ratesInfo = try decoder.decode([ExchangeRatesAPIModel].self, from: data)
                completion(.success(ratesInfo))
            } catch { completion(.failure(.decodingError(error))) }
        }

        task.resume()
    }
}
