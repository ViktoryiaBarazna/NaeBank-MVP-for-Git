//
//  ExchangeRateCellViewModel.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 4.05.26.
//

// MARK: - ViewModel для ячейки таблицы (только то, что нужно для отображения)

struct ExchangeRatesCellViewModel {
    let departmentName: String
    let cityName: String
    let address: String

    init(from model: ExchangeRatesAPIModel) {
        self.departmentName = model.filials_text
        self.cityName = model.name
        self.address = "\(model.street_type) \(model.street) \(model.home_number)"
    }
}
