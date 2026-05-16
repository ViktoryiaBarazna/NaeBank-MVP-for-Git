//
//  RegistrationService.swift
//  NaeBank
//

import Foundation

final class RegistrationService: RegistrationServiceProtocol {

    private let keychain: RegisterKeychainStoreProtocol
    private let validator: RegisterFormValidator

    init(
        keychain: RegisterKeychainStoreProtocol,
        validator: RegisterFormValidator = RegisterFormValidator()
    ) {
        self.keychain = keychain
        self.validator = validator
    }

    func register(phone: String?, password: String?, repeatPassword: String?, termsAccepted: Bool)
    -> RegistrationResult
    {
        switch validator.validate(
            phone: phone, password: password, repeatPassword: repeatPassword,
            termsAccepted: termsAccepted)
        {
        case .problems(let messages, let fields):
            return .invalidForm(messages: messages, fields: fields)
        case .ok(let credentials):
            if keychain.isPhoneRegistered(credentials.phone) { return .phoneAlreadyRegistered }
            if !keychain.savePassword(phone: credentials.phone, password: credentials.password) {
                return .saveFailed
            }
            persistSession(phone: credentials.phone)
            return .registered(credentials)
        }
    }

    private func persistSession(phone: String) {
        let defaults = UserDefaults.standard
        defaults.set(phone, forKey: "savedPhone")
        defaults.set(true, forKey: "isLoggedIn")
        defaults.set(true, forKey: "onboardingCompleted")
    }
}
