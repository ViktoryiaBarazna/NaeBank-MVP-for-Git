//
//  ExchangeRatesProtocols.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 3.05.26.
//

import Foundation

protocol ExchangeRatesViewProtocol: AnyObject {
    func showContent(_ viewModel: ExchangeRatesViewModel)
    func showLoading()
    func hideLoading()
}
