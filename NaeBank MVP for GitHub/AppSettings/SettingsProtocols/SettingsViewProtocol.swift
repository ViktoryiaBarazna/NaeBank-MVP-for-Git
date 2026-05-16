//
//  SettingsViewProtocol.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 11.05.26.
//

import Foundation

protocol SettingsViewProtocol: AnyObject {
    func updateThemeSelection(_ theme: AppTheme)
    func updateNotificationsSwitch(isOn: Bool)
    func showNotificationDeniedAlert()
    func showLogoutConfirmation()
    func showError(_ message: String)
}
