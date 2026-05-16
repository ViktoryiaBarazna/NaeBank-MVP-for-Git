//
//  RegistrationResult.swift
//  NaeBank
//

import Foundation

/// Итог регистрации
enum RegistrationResult {
    /// Успех: пользователь сохранён, можно переходить дальше.
    case registered(RegisterCredentials)
    /// Ошибки по полям формы + тексты для алерта.
    case invalidForm(messages: [String], fields: RegisterInvalidFields)
    case phoneAlreadyRegistered
    case saveFailed
}
