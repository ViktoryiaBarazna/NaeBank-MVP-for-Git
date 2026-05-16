//
//  LoginInvailidFields.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 11.05.26.
//

import Foundation

/// Какие поля подсветить при ошибке.
struct LoginInvalidFields: Equatable {
    var phone = false
    var password = false
}
