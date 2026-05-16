//
//  LoginService.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 11.05.26.
//

import Foundation

final class LoginService: LoginServiceProtocol {

    private let keychain: LoginKeychainStoreProtocol
    private let validator: LoginFormValidator

    init(keychain: LoginKeychainStoreProtocol, validator: LoginFormValidator = LoginFormValidator()) {
        self.keychain = keychain
        self.validator = validator
    }

    func login(phone: String?, password: String?) -> LoginResult {
        switch validator.validate(phone: phone, password: password) {
        case .problems(let messages, let fields):
            return .invalidForm(messages: messages, fields: fields)
        case .ok(let credentials):
            if !keychain.isPhoneRegistered(credentials.phone) { return .phoneNotRegistered }
            guard let savedPassword = keychain.loadPasswordFromKeychain(phone: credentials.phone)
            else { return .loginFailed }
            if savedPassword != credentials.password { return .invalidPassword }
            persistSession(phone: credentials.phone)
            return .loggedIn(credentials)
        }
    }

    private func persistSession(phone: String) {
        let defaults = UserDefaults.standard
        defaults.set(phone, forKey: "savedPhone")
        defaults.set(true, forKey: "isLoggedIn")
        defaults.set(true, forKey: "onboardingCompleted")
    }
}
