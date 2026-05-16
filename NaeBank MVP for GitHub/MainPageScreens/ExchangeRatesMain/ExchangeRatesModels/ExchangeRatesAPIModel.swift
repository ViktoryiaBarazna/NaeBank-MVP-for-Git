//
//  Exchange Rates.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 26.04.26.
//

// MARK: - API Model (все данные, что получаем с сервера)

import Foundation

struct ExchangeRatesAPIModel: Codable {
    let USD_in: String
    let USD_out: String
    let EUR_in: String
    let EUR_out: String
    let RUB_in: String
    let RUB_out: String
    let CNY_in: String
    let CNY_out: String
    let filials_text: String
    let info_worktime: String
    let name_type: String
    let name: String
    let street_type: String
    let street: String
    let home_number: String
}
