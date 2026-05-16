//
//  LoginPresenter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 10.05.26.
//

import Foundation

final class LoginPresenter: LoginPresenterProtocol {

    weak var view: LoginViewProtocol?
    var router: LoginRouterProtocol
    private let loginService: LoginServiceProtocol

    init(router: LoginRouterProtocol, loginService: LoginServiceProtocol) {
        self.router = router
        self.loginService = loginService
    }

    func loginButtonDidTapped(phone: String?, password: String?) {
        view?.resetInvalidFieldHighlighting()

        switch loginService.login(phone: phone, password: password) {
        case .loggedIn(let credentials):
            view?.applyTrimmedPhone(credentials.phone)
            router.showMainPage()

        case .invalidForm(let messages, let fields):
            view?.showInvalidFields(fields)
            view?.showAlert(title: "error".localized, message: messages.joined(separator: "\n"))

        case .phoneNotRegistered:
            view?.showInvalidFields(LoginInvalidFields(phone: true, password: false))
            view?.showAlert(
                title: "error".localized,
                message: "login_account_not_found".localized)

        case .invalidPassword:
            view?.showInvalidFields(LoginInvalidFields(phone: false, password: true))
            view?.clearPasswordField()
            view?.showAlert(title: "error".localized, message: "login_password_incorrect".localized)

        case .loginFailed:
            view?.showAlert(title: "error".localized, message: "login_data_load_failed".localized)
        }
    }

    func registerButtonDidTapped() { router.showRegisterPage() }
}
