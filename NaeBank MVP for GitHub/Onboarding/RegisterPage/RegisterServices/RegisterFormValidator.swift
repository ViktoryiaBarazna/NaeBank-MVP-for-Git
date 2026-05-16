//
//  RegisterFormValidator.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 9.05.26.
//

import Foundation

struct RegisterFormValidator {

    enum Outcome {
        case ok(RegisterCredentials)
        case problems(messages: [String], fields: RegisterInvalidFields)
    }

    func validate(phone: String?, password: String?, repeatPassword: String?, termsAccepted: Bool)
    -> Outcome
    {
        var messages: [String] = []
        var invalid = RegisterInvalidFields()

        if let msg = phoneValidationMessage(phone) {
            messages.append(msg)
            invalid.phone = true
        }
        if let msg = passwordValidationMessage(password) {
            messages.append(msg)
            invalid.password = true
        }
        if let msg = repeatPasswordValidationMessage(
            password: password, repeatPassword: repeatPassword)
        {
            messages.append(msg)
            invalid.repeatPassword = true
        }
        if !termsAccepted {
            messages.append("register_terms_not_accepted".localized)
            invalid.terms = true
        }

        if !messages.isEmpty { return .problems(messages: messages, fields: invalid) }

        guard let rawPhone = phone, let pwd = password else {
            return .problems(
                messages: ["check_login_and_password".localized],
                fields: RegisterInvalidFields(phone: true, password: true))
        }
        let trimmed = rawPhone.trimmingCharacters(in: .whitespaces)
        return .ok(RegisterCredentials(phone: trimmed, password: pwd))
    }

    private func phoneValidationMessage(_ enteredPhone: String?) -> String? {
        guard let enteredPhone, !enteredPhone.isEmpty else { return "register_phone_not_entered".localized}
        let trimmedPhone = enteredPhone.trimmingCharacters(in: .whitespaces)
        let phoneRegex = "^\\+375[0-9]{9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        if !phonePredicate.evaluate(with: trimmedPhone) {
            return "fill_phone_number".localized
        }
        return nil
    }

    private func passwordValidationMessage(_ password: String?) -> String? {
        guard let password, !password.isEmpty else { return "register_password_not_entered".localized }
        let hasMinLength = password.count >= 8
        let hasDigit = password.rangeOfCharacter(from: .decimalDigits) != nil
        if !(hasMinLength && hasDigit) {
            return "register_password_requirements_not_met".localized
        }
        return nil
    }

    private func repeatPasswordValidationMessage(password: String?, repeatPassword: String?)
    -> String?
    {
        guard let repeatPassword, !repeatPassword.isEmpty else {
            return "register_repeat_password_not_entered".localized
        }
        guard let password, password == repeatPassword else { return "register_passwords_do_not_match".localized}
        return nil
    }
}
