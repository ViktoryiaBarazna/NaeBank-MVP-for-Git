import Foundation

protocol ExchangeRatesServiceProtocol {
    func fetchRates(completion: @escaping (Result<[ExchangeRatesAPIModel], NetworkError>) -> Void)
}
