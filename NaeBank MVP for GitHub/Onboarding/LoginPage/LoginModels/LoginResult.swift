//
//  LoginResult.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 11.05.26.
//

import Foundation

enum LoginResult {
    case loggedIn(LoginCredentials)
    case invalidForm(messages: [String], fields: LoginInvalidFields)
    case phoneNotRegistered
    case invalidPassword
    case loginFailed
}
