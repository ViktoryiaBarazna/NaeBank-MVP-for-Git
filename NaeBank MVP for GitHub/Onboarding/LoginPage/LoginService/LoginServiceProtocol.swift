//
//  LoginServiceProtocol.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 11.05.26.
//

import Foundation

protocol LoginServiceProtocol {
    func login(phone: String?, password: String?) -> LoginResult
}
