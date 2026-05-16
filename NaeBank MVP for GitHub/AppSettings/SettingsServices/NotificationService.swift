//
//  NotificationService.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 9.05.26.
//

import Foundation
import UserNotifications

final class NotificationService {

    static let shared = NotificationService()
    private let notificationsKey = "notificationsEnabled"

    private init() {}

    func isEnabled() -> Bool { return UserDefaults.standard.bool(forKey: notificationsKey) }

    func setEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: notificationsKey)
    }

    func requestPermissionAndSchedule(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            granted, _ in
            DispatchQueue.main.async {
                if granted {
                    self.scheduleDailyNotification()
                    self.setEnabled(true)
                }
                completion(granted)
            }
        }
    }

    func scheduleDailyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "NaeBank 🏦"
        content.body = getRandomMessage()
        content.sound = .default
        content.badge = 1

        var dateComponents = DateComponents()
        dateComponents.hour = 12
        dateComponents.minute = 30

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: "dailyNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [
            "dailyNotification"
        ])
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error { print("Ошибка: \(error.localizedDescription)") }
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [
            "dailyNotification"
        ])
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        setEnabled(false)
    }

    func checkPermissionAndScheduleIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized, .provisional: self.scheduleDailyNotification()
                case .denied: self.setEnabled(false)
                case .notDetermined: break
                default: break
                }
            }
        }
    }

    private func getRandomMessage() -> String {
        let messages = [
            "settings_notification_message1".localized,
            "settings_notification_message2".localized,
            "settings_notification_message3".localized,
            "settings_notification_message4".localized,
            "settings_notification_message5".localized,
        ]
        return messages.randomElement() ?? "settings_notification_message3".localized
    }
}
