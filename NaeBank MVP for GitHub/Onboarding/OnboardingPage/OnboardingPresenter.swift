//
//  OnboardingPresenter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 9.05.26.
//

import Foundation

final class OnboardingPresenter: OnboardingPresenterProtocol {

    var router: OnboardingRouterProtocol

    init(router: OnboardingRouterProtocol) { self.router = router }

    func loginButtonDidTapped() {
        UserDefaults.standard.set(true, forKey: "onboardingCompleted")
        router.showLoginScreen()
    }

    func registerButtonDidTapped() {
        UserDefaults.standard.set(true, forKey: "onboardingCompleted")
        router.showRegisterScreen()
    }
}
