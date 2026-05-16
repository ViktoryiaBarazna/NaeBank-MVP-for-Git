//
//  RatesViewModel.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 3.05.26.
//

import Foundation

// MARK: - ViewModel для всего экрана

struct ExchangeRatesViewModel {

    let rates: [ExchangeRatesAPIModel]
    let cellViewModels: [ExchangeRatesCellViewModel]
    let title: String
    let errorMessage: String?

}
