//
//  RegisterInvalidFields.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 9.05.26.
//

import Foundation

/// Какие поля подсветить при ошибке.
struct RegisterInvalidFields: Equatable {
    var phone = false
    var password = false
    var repeatPassword = false
    var terms = false
}
