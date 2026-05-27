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

    func showMainPage() {
        guard
            let window = viewController?.view.window
                ?? viewController?.navigationController?.view.window
        else { return }
        let tabBarVC = MainTabBarViewController()
        UIView.transition(
            with: window, duration: 0.35, options: .transitionCrossDissolve,
            animations: { window.rootViewController = tabBarVC })
    }
}
