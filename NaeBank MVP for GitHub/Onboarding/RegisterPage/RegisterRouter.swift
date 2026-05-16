//
//  RegisterRouter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 9.05.26.
//

import UIKit

final class RegisterRouter: RegisterRouterProtocol {

    weak var viewController: UIViewController?

    func showAfterRegisterScreen() {
        let afterRegisterVC = AfterRegisterViewController.build()
        viewController?.navigationController?.pushViewController(afterRegisterVC, animated: true)
    }

    func showLoginScreen() {
        let loginVC = LoginViewController.build()
        viewController?.navigationController?.pushViewController(loginVC, animated: true)
    }
}
