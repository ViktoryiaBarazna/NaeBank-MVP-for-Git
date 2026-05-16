//
//  NetworkError.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 26.04.26.
//

import Foundation

// MARK: - Ошибки сети

enum NetworkError: Error, LocalizedError {
    case invalidURL  // Неверный URL (например, опечатка в адресе)
    case noData  // Сервер вернул пустой ответ
    case httpError(statusCode: Int)  // HTTP ошибка (404, 500 и т.д.)
    case decodingError(Error)  // Не удалось распарсить JSON
    case networkError(Error)  // Проблема с интернетом

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "network_error_invalid_url".localized
        case .noData:
            return "network_error_empty_response".localized
        case .httpError(let statusCode):
            return "network_error_http_status".localized(statusCode)
        case .decodingError(let error):
            return "network_error_decoding".localized(error.localizedDescription)
        case .networkError(let error):
            return "network_error_connection".localized(error.localizedDescription)
        }
    }
}
