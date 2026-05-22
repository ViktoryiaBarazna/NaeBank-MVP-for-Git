//
//  SetupPageViewController.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 27.04.26.
//

import UIKit
import SnapKit

final class SettingsViewController: UIViewController {

    // MARK: - MVP
    var presenter: SettingsPresenterProtocol?

    // MARK: - Subviews
    private let themeLabel = UILabel()
    private let segmentControl = UISegmentedControl()
    private let notificationsLabel = UILabel()
    private let notificationsSwitch = UISwitch()
    private let containerView = UIView()
    private let logoutButton = UIButton()

    // MARK: - Build
    static func build() -> UIViewController {
        let presenter = SettingsPresenter()
        let router = SettingsRouter()
        let vc = SettingsViewController()

        presenter.view = vc
        presenter.router = router
        router.viewController = vc
        vc.presenter = presenter

        return vc
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewProperties()
        setupSubviews()
        setupConstraintsSnapKit()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }

    // MARK: - Setup
    private func setupViewProperties() {
        title = "settings_title".localized
        view.backgroundColor = .systemBackground
    }

    private func setupSubviews() {
        themeLabel.text = "settings_theme_title".localized
        themeLabel.font = .systemFont(ofSize: 17, weight: .medium)
        themeLabel.textColor = .label

        segmentControl.insertSegment(withTitle: "settings_light_theme".localized, at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "settings_dark_theme".localized, at: 1, animated: false)
        segmentControl.insertSegment(withTitle: "settings_system_theme".localized, at: 2, animated: false)
        segmentControl.addTarget(self, action: #selector(themeChanged), for: .valueChanged)

        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 12

        notificationsLabel.text = "settings_get_notification_toggle".localized
        notificationsLabel.font = .systemFont(ofSize: 17, weight: .medium)
        notificationsLabel.textColor = .label

        notificationsSwitch.addTarget(
            self, action: #selector(notificationSwitchChanged), for: .valueChanged)

        logoutButton.setTitle("logout_button".localized, for: .normal)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logoutButton.backgroundColor = .systemRed
        logoutButton.setTitleColor(.white, for: .normal)
        logoutButton.layer.cornerRadius = 15
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)

        view.addSubview(containerView)
        view.addSubview(logoutButton)
        [themeLabel, segmentControl, notificationsLabel, notificationsSwitch].forEach {
            containerView.addSubview($0)
        }
    }


    private func setupConstraintsSnapKit() {
        containerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.trailing.equalTo(view).inset(16)
        }

        themeLabel.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top).offset(16)
            $0.leading.trailing.equalTo(containerView).inset(16)
        }

        segmentControl.snp.makeConstraints {
            $0.top.equalTo(themeLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(containerView).inset(16)
        }

        notificationsLabel.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(24)
            $0.leading.equalTo(containerView).inset(16)
        }

        notificationsSwitch.snp.makeConstraints {
            $0.centerY.equalTo(notificationsLabel.snp.centerY)
            $0.trailing.equalTo(containerView.snp.trailing).offset(-16)
            $0.bottom.equalTo(containerView.snp.bottom).offset(-16)
        }

        logoutButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(containerView.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(view).inset(80)
            $0.height.equalTo(50)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-80).priority(.high)
        }
    }

    // MARK: - Actions
    @objc private func themeChanged() {
        let selectedTheme: AppTheme

        switch segmentControl.selectedSegmentIndex {
        case 0: selectedTheme = .light
        case 1: selectedTheme = .dark
        default: selectedTheme = .system
        }

        presenter?.themeSelected(selectedTheme)
    }

    @objc private func notificationSwitchChanged() {
        presenter?.notificationsSwitchToggled(notificationsSwitch.isOn)
    }

    @objc private func logoutButtonTapped() { presenter?.logoutButtonTapped() }
}

// MARK: - SettingsViewProtocol
extension SettingsViewController: SettingsViewProtocol {

    func updateThemeSelection(_ theme: AppTheme) {
        switch theme {
        case .light: segmentControl.selectedSegmentIndex = 0
        case .dark: segmentControl.selectedSegmentIndex = 1
        case .system: segmentControl.selectedSegmentIndex = 2
        }
    }

    func updateNotificationsSwitch(isOn: Bool) { notificationsSwitch.isOn = isOn }

    func showNotificationDeniedAlert() {
        let alert = UIAlertController(
            title: "settings_notification_off".localized,
            message:
                "settings_notification_permission".localized,
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel))
        alert.addAction(
            UIAlertAction(title: "settings".localized, style: .default) { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            })

        present(alert, animated: true)
    }

    func showLogoutConfirmation() {
        let alert = UIAlertController(
            title: "settings_want_off".localized, message: "settings_sure_off".localized,
            preferredStyle: .alert)

        let logoutAction = UIAlertAction(title: "settings_yes_off".localized, style: .destructive) { [weak self] _ in
            self?.presenter?.logoutConfirmed()
        }

        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel)

        alert.addAction(logoutAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func showError(_ message: String) {
        let alert = UIAlertController(title: "error".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
