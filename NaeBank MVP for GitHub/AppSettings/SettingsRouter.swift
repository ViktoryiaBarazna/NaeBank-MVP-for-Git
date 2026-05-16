//
//  SettingsRouter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 9.05.26.
//

import UIKit

final class SettingsRouter: SettingsRouterProtocol {

    weak var viewController: UIViewController?

    func navigateToLogin() {
        // Сначала получаем текущую сцену
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate,
            let window = sceneDelegate.window
        else {
            print("Не удалось найти окно для навигации")
            return
        }

        let loginVC = LoginViewController.build()
        let navController = UINavigationController(rootViewController: loginVC)

        // Анимируем переход
        UIView.transition(
            with: window, duration: 0.5, options: .transitionCrossDissolve,
            animations: { window.rootViewController = navController })
    }
}
