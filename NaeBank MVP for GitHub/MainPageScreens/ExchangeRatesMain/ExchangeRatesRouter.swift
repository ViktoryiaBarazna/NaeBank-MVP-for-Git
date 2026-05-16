//
//  ExchangeRatesRouter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 3.05.26.
//

import UIKit

final class ExchangeRatesRouter: ExchangeRatesRouterProtocol {

    weak var viewController: UIViewController?

    func openDetails(for rate: ExchangeRatesAPIModel) {
        let detailVC = ExchangeRatesDetailViewController.build(department: rate)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
