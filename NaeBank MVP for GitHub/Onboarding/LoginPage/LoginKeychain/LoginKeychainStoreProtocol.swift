//
//  LoginKeychainStoreProtocol.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 10.05.26.
//

import Foundation

protocol LoginKeychainStoreProtocol {

    func isPhoneRegistered(_ phone: String) -> Bool
    func loadPasswordFromKeychain(phone: String) -> String?
}
