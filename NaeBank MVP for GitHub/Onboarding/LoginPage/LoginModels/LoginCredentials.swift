//
//  LoginCredentials.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 10.05.26.
//

import Foundation

/// Данные после успешной проверки формы (телефон + пароль).
struct LoginCredentials: Equatable {
    let phone: String
    let password: String
}
