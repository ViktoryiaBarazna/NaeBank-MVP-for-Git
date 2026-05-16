//
//  LoginKeychainStore.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 10.05.26.
//

import Foundation
import Security

final class LoginKeychainStore: LoginKeychainStoreProtocol {

    private let service: String

    init(service: String = "com.naebank.finance") { self.service = service }

    // Проверяет, существует ли пользователь с таким телефоном в Keychain
    func isPhoneRegistered(_ phone: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service,
            kSecAttrAccount as String: phone, kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    // Загрузка пароля из Keychain
    func loadPasswordFromKeychain(phone: String) -> String? {
        let account = phone.trimmingCharacters(in: .whitespaces)

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service,
            kSecAttrAccount as String: account, kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data,
           let password = String(data: data, encoding: .utf8)
        {
            return password
        }
        return nil
    }
}
