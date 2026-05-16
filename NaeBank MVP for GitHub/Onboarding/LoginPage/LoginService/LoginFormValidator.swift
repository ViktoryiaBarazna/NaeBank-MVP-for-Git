//
//  LoginFormValidator.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 11.05.26.
//

import Foundation

struct LoginFormValidator {

    enum Outcome {
        case ok(LoginCredentials)
        case problems(messages: [String], fields: LoginInvalidFields)
    }

    func validate(phone: String?, password: String?) -> Outcome {
        var messages: [String] = []
        var invalid = LoginInvalidFields()

        if let msg = phoneValidationMessage(phone) {
            messages.append(msg)
            invalid.phone = true
        }
        if let msg = passwordValidationMessage(password) {
            messages.append(msg)
            invalid.password = true
        }
        if !messages.isEmpty { return .problems(messages: messages, fields: invalid) }

        guard let rawPhone = phone, let pwd = password else {
            return .problems(
                messages: ["check_login_and_password".localized],
                fields: LoginInvalidFields(phone: true, password: true))
        }
        let trimmed = rawPhone.trimmingCharacters(in: .whitespaces)
        return .ok(LoginCredentials(phone: trimmed, password: pwd))
    }

    private func phoneValidationMessage(_ enteredPhone: String?) -> String? {
        guard let enteredPhone, !enteredPhone.isEmpty else {
            return "login_phone_not_entered".localized
        }
        let trimmedPhone = enteredPhone.trimmingCharacters(in: .whitespaces)
        let phoneRegex = "^\\+375[0-9]{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if !phonePredicate.evaluate(with: trimmedPhone) {
            return "login_phone_invalid_format".localized
        }
        return nil
    }

    private func passwordValidationMessage(_ password: String?) -> String? {
        guard let password, !password.isEmpty else {
            return "login_password_not_entered".localized
        }
        return nil
    }
}
