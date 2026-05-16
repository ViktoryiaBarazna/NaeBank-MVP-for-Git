//
//  AfterRegisterRouter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 9.05.26.
//

import UIKit

final class AfterRegisterRouter: AfterRegisterRouterProtocol {

    weak var viewController: UIViewController?

    func showLoginScreen() {
        let loginVC = LoginViewController.build()
        viewController?.navigationController?.pushViewController(loginVC, animated: true)
    }
}
