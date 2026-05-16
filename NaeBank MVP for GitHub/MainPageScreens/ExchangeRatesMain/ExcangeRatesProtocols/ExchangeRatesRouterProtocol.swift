//
//  ExchangeRatesRouterProtocol.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 11.05.26.
//

import Foundation

protocol ExchangeRatesRouterProtocol: AnyObject {
    func openDetails(for rate: ExchangeRatesAPIModel)
}
