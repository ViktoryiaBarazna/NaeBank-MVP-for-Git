//
//  MapsNetworkService.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 24.05.26.
//

import Foundation

final class MapsNetworkService: MapsServiceProtocol {

    static let shared = MapsNetworkService()

    private let baseURL = "https://belarusbank.by"
    private let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.waitsForConnectivity = true
        session = URLSession(configuration: configuration)
    }

    func fetchBranches(completion: @escaping (Result<[BranchMapItem], NetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/open-banking/v1.0/banks/AKBBBY2X/branches") else {
            completion(.failure(.invalidURL))
            return
        }

        session.dataTask(with: url) { data, response, error in
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

            do {
                let branches = try Self.parseBranches(from: data)
                completion(.success(branches))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }

    private static func parseBranches(from data: Data) throws -> [BranchMapItem] {
        guard
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let dataNode = json["data"] as? [String: Any],
            let bank = dataNode["bank"] as? [String: Any],
            let branchList = bank["branch"] as? [[String: Any]]
        else {
            throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unexpected branches JSON"))
        }

        return branchList.compactMap { branch in
            guard
                let address = branch["postalAddress"] as? [String: Any],
                let geo = address["geolocation"] as? [String: Any],
                let latitude = double(from: geo["latitude"]),
                let longitude = double(from: geo["longitude"])
            else { return nil }

            let name = (branch["name"] as? String)?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !name.isEmpty else { return nil }

            let segment = (branch["information"] as? [[String: Any]])?.first?["segment"] as? String
            return BranchMapItem(
                name: name,
                latitude: latitude,
                longitude: longitude,
                clientType: BranchClientType(apiSegment: segment)
            )
        }
    }

    private static func double(from value: Any?) -> Double? {
        if let string = value as? String { return Double(string) }
        if let number = value as? Double { return number }
        if let number = value as? Int { return Double(number) }
        return nil
    }
}
