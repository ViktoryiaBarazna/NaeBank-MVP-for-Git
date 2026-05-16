//
//  ThemeManager.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 27.04.26.
//

import UIKit

final class ThemeManager {

    static let shared = ThemeManager()
    private let themeKey = "selected_app_theme"

    private init() { if UserDefaults.standard.object(forKey: themeKey) == nil { saveTheme(.dark) } }

    func saveTheme(_ theme: AppTheme) {
        UserDefaults.standard.set(theme.rawValue, forKey: themeKey)
    }

    func getSavedTheme() -> AppTheme {
        let savedTheme = UserDefaults.standard.integer(forKey: themeKey)
        return AppTheme(rawValue: savedTheme) ?? .dark
    }

    func applyTheme() {
        let theme = getSavedTheme()
        let style: UIUserInterfaceStyle

        switch theme {
        case .light: style = .light
        case .dark: style = .dark
        case .system: style = .unspecified
        }

        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap {
            $0.windows
        }.forEach { $0.overrideUserInterfaceStyle = style }
    }

    func applyTheme(_ theme: AppTheme) {
        let style: UIUserInterfaceStyle

        switch theme {
        case .light: style = .light
        case .dark: style = .dark
        case .system: style = .unspecified
        }

        UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap {
            $0.windows
        }.forEach { $0.overrideUserInterfaceStyle = style }
    }
}
