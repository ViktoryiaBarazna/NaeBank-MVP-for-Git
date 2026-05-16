//
//  MainPagePresenter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 2.05.26.
//

import Foundation

final class MainPagePresenter: MainPagePresenterProtocol {

    var router: MainPageRouterProtocol

    init(router: MainPageRouterProtocol) {
        self.router = router
    }

    func exchangeRatesDidTapped() {
        router.openExchangeRates()
    }

    func newsDidTapped() {
        router.openNews()
    }
}
