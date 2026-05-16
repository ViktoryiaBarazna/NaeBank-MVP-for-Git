//
//  RegisterKeychainStore.swift
//  NaeBank
//

import Foundation

protocol RegisterKeychainStoreProtocol {
    /// `true`, если для номера уже есть запись в Keychain.
    func isPhoneRegistered(_ phone: String) -> Bool
    /// Сохраняет пароль для номера. `false` — дубликат или ошибка записи.
    func savePassword(phone: String, password: String) -> Bool
}
