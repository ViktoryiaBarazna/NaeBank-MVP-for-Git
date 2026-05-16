//
//  RegisterKeychainStore 2.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 9.05.26.
//

import Foundation
import Security

final class RegisterKeychainStore: RegisterKeychainStoreProtocol {

    private let service: String

    init(service: String = "com.naebank.finance") { self.service = service }

    func isPhoneRegistered(_ phone: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service,
            kSecAttrAccount as String: phone, kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    func savePassword(phone: String, password: String) -> Bool {
        guard let passwordData = password.data(using: .utf8) else { return false }

        let checkQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service,
            kSecAttrAccount as String: phone, kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        if SecItemCopyMatching(checkQuery as CFDictionary, nil) == errSecSuccess { return false }

        let addQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service,
            kSecAttrAccount as String: phone, kSecValueData as String: passwordData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked,
        ]
        return SecItemAdd(addQuery as CFDictionary, nil) == errSecSuccess
    }
}
