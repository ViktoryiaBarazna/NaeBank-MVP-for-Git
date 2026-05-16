//
//  SettingsPresenter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 9.05.26.
//

import Foundation

final class SettingsPresenter: SettingsPresenterProtocol {

    weak var view: SettingsViewProtocol?
    var router: SettingsRouterProtocol?

    private let notificationService = NotificationService.shared

    // MARK: - Lifecycle
    func viewDidLoad() {
        loadTheme()
        loadNotificationSettings()
    }

    func viewWillAppear() { loadTheme() }

    // MARK: - Theme
    func themeSelected(_ theme: AppTheme) {
        ThemeManager.shared.saveTheme(theme)
        ThemeManager.shared.applyTheme(theme)
        view?.updateThemeSelection(theme)
    }

    // MARK: - Notifications
    func notificationsSwitchToggled(_ isOn: Bool) {
        if isOn {
            notificationService.requestPermissionAndSchedule { [weak self] granted in
                if !granted {
                    self?.view?.updateNotificationsSwitch(isOn: false)
                    self?.view?.showNotificationDeniedAlert()
                }
            }
        } else {
            notificationService.cancelAllNotifications()
        }
    }

    // MARK: - Logout
    func logoutButtonTapped() { view?.showLogoutConfirmation() }

    func logoutConfirmed() {
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        router?.navigateToLogin()
    }

    // MARK: - Private
    private func loadTheme() {
        let savedTheme = ThemeManager.shared.getSavedTheme()
        view?.updateThemeSelection(savedTheme)
    }

    private func loadNotificationSettings() {
        let isEnabled = notificationService.isEnabled()
        view?.updateNotificationsSwitch(isOn: isEnabled)

        if isEnabled { notificationService.checkPermissionAndScheduleIfNeeded() }
    }
}
