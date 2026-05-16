//
//  NewsServiceProtocol.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 26.04.26.
//

import Foundation

protocol NewsServiceProtocol {
    func fetchNews(completion: @escaping (Result<[NewsAPIModel], NetworkError>) -> Void)
}
