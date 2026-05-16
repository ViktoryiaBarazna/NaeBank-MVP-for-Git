//
//  RegisterCredentials.swift
//  NaeBank
//

import Foundation

/// Данные после успешной проверки формы
struct RegisterCredentials: Equatable {
    let phone: String
    let password: String
}
