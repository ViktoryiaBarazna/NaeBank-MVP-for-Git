//
//  RegisterPresenter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 9.05.26.
//

import Foundation

final class RegisterPresenter: RegisterPresenterProtocol {

    weak var view: RegisterViewProtocol?
    var router: RegisterRouterProtocol
    private let registrationService: RegistrationServiceProtocol

    init(router: RegisterRouterProtocol, registrationService: RegistrationServiceProtocol) {
        self.router = router
        self.registrationService = registrationService
    }

    func registerTapped(
        phone: String?, password: String?, repeatPassword: String?, termsAccepted: Bool
    ) {
        view?.resetInvalidFieldHighlighting()

        switch registrationService.register(
            phone: phone, password: password, repeatPassword: repeatPassword,
            termsAccepted: termsAccepted)
        {
        case .registered(let credentials):
            view?.applyTrimmedPhone(credentials.phone)
            router.showAfterRegisterScreen()

        case .invalidForm(let messages, let fields):
            view?.showInvalidFields(fields)
            view?.showAlert(title: "error".localized, message: messages.joined(separator: "\n"))

        case .phoneAlreadyRegistered:
            view?.showInvalidFields(RegisterInvalidFields(phone: true))
            view?.showAlert(title: "error".localized, message: "register_phone_already_registered".localized)

        case .saveFailed:
            view?.showAlert(
                title: "error".localized,
                message: "register_credentials_save_failed".localized)
        }
    }

    func loginButtonDidTapped() { router.showLoginScreen() }
}
