//
//  RegisterPresenter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 9.05.26.
//

import GoogleSignIn
import UIKit

final class RegisterPresenter: RegisterPresenterProtocol {

    weak var view: RegisterViewProtocol?
    var router: RegisterRouterProtocol
    private let registrationService: RegistrationServiceProtocol
    private let googleAuthService: GoogleAuthServiceProtocol

    init(
        router: RegisterRouterProtocol,
        registrationService: RegistrationServiceProtocol,
        googleAuthService: GoogleAuthServiceProtocol
    ) {
        self.router = router
        self.registrationService = registrationService
        self.googleAuthService = googleAuthService
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

    func googleButtonTapped(presentingViewController: UIViewController) {
        googleAuthService.signIn(presentingViewController: presentingViewController) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success:
                    self.router.showMainPage()
                case .failure(let error):
                    let nsError = error as NSError
                    if nsError.domain == GIDSignInError.errorDomain,
                       nsError.code == GIDSignInError.canceled.rawValue
                    {
                        return
                    }
                    self.view?.showAlert(
                        title: "error".localized,
                        message: error.localizedDescription)
                }
            }
        }
    }

    func loginButtonDidTapped() { router.showLoginScreen() }
}
