//
//  SettingsPresenterProtocol.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 11.05.26.
//

import Foundation

protocol SettingsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func themeSelected(_ theme: AppTheme)
    func notificationsSwitchToggled(_ isOn: Bool)
    func logoutButtonTapped()
    func logoutConfirmed()
}
