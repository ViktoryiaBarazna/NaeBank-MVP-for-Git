//
//  LoginRouter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 10.05.26.
//

import UIKit

final class LoginRouter: LoginRouterProtocol {

    weak var viewController: UIViewController?

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

    func showRegisterPage() {
        let registerVC = RegisterViewController.build()
        viewController?.navigationController?.pushViewController(registerVC, animated: true)
    }
}
