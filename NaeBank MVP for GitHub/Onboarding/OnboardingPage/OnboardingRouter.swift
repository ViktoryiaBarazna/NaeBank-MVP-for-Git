//
//  OnboardingRouter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 9.05.26.
//

import UIKit

final class OnboardingRouter: OnboardingRouterProtocol {

    weak var viewController: UIViewController?

    func showLoginScreen() {
        let loginVC = LoginViewController.build()
        viewController?.navigationController?.pushViewController(loginVC, animated: true)
    }

    func showRegisterScreen() {
        let registerVC = RegisterViewController.build()
        viewController?.navigationController?.pushViewController(registerVC, animated: true)
    }
}
