//
//  AfterRegisterPresenter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 9.05.26.
//

import Foundation

final class AfterRegisterPresenter: AfterRegisterPresenterProtocol {

    var router: AfterRegisterRouterProtocol

    init(router: AfterRegisterRouterProtocol) {
        self.router = router
    }

    func loginButtonDidTapped() {
        router.showLoginScreen()
    }
}
