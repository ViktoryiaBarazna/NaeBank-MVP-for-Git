//
//  MainPageRouter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 2.05.26.
//

import UIKit

final class MainPageRouter: MainPageRouterProtocol {

    weak var viewController: UIViewController?

    func openExchangeRates() {
        let exchangeVC = ExchangeRatesMainViewController.build()
        viewController?.navigationController?.pushViewController(exchangeVC, animated: true)
    }

    func openNews() {
        let newsVC = NewsMainViewController.build()
        viewController?.navigationController?.pushViewController(newsVC, animated: true)
    }
}
