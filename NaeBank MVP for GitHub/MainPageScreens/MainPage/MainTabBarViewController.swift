//
//  MainTabBarViewController.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 1.04.26.
//

import UIKit

final class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        configureTabBarAppearance()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupStatusBar()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let statusBarView = view.window?.viewWithTag(999) {
            let statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
            statusBarView.frame = statusBarFrame
        }
    }

    // MARK: - Status Bar Setup
    private func setupStatusBar() {
        // Проверяем, чтобы не добавить второй раз
        guard view.window?.viewWithTag(999) == nil else { return }

        let statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
        let statusBarView = UIView(frame: statusBarFrame)
        statusBarView.tag = 999
        statusBarView.translatesAutoresizingMaskIntoConstraints = false

        view.window?.addSubview(statusBarView)

        updateStatusBarColor()
    }

    func updateStatusBarColor() {
        let statusBarView = view.window?.viewWithTag(999)
        if traitCollection.userInterfaceStyle == .dark {
            statusBarView?.backgroundColor = .black
        } else {
            statusBarView?.backgroundColor = .white
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateStatusBarColor()
        }
    }

    // MARK: - Tab Bar Configuration
    private func configureTabBarAppearance() {
        tabBar.tintColor = .systemPurple
        tabBar.unselectedItemTintColor = .secondaryLabel

        // Для iOS 15+ (убирает прозрачность)
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }

    private func setupTabs() {
        let mainVC = MainPageViewController.build()
        let setupVC = SettingsViewController.build()

        let mainNav = UINavigationController(rootViewController: mainVC)
        let setupNav = UINavigationController(rootViewController: setupVC)

        mainNav.tabBarItem = UITabBarItem(
            title: "tabbar_main".localized, image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill"))

        setupNav.tabBarItem = UITabBarItem(
            title: "tabbar_setups".localized, image: UIImage(systemName: "gear"),
            selectedImage: UIImage(systemName: "gear.fill"))

        viewControllers = [mainNav, setupNav]
    }
}
