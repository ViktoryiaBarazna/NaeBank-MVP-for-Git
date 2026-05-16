//
//  RegistrationServiceProtocol.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 9.05.26.
//

import Foundation

protocol RegistrationServiceProtocol {
    func register(phone: String?, password: String?, repeatPassword: String?, termsAccepted: Bool)
    -> RegistrationResult
}
