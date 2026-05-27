//
//  MainPageViewController.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 1.04.26.
//

import UIKit
import SnapKit
import FirebaseAnalytics

final class MainPageViewController: UIViewController {

    // MARK: - MVP
    var presenter: MainPagePresenterProtocol?

    // MARK: - Subviews
    private let titleLabel = UILabel()
    private let ratesLabel = UILabel()
    private let ratesButton = UIButton(type: .system)
    private let newsLabel = UILabel()
    private let newsButton = UIButton(type: .system)

    // MARK: - Build

    static func build() -> UIViewController {

        let router = MainPageRouter()
        let presenter = MainPagePresenter(router: router)
        let vc = MainPageViewController()

        router.viewController = vc
        vc.presenter = presenter

        return vc
    }

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultBackground()
        setupSubViews()
        setupConstraintsSnapKit()
    }

    // MARK: - Layout

    private func setupSubViews() {
        titleLabel.text =  "main_page_title".localized
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemMint

        ratesLabel.text = "main_page_subtitle1".localized
        ratesLabel.font = .systemFont(ofSize: 16, weight: .medium)
        ratesLabel.numberOfLines = 0
        ratesLabel.textAlignment = .left
        ratesLabel.textColor = .systemPurple

        ratesButton.setTitle("main_page_exchange_rates_button".localized, for: .normal)
        ratesButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        ratesButton.backgroundColor = .systemPurple
        ratesButton.setTitleColor(.white, for: .normal)
        ratesButton.layer.cornerRadius = 15
        ratesButton.addTarget(self, action: #selector(ratesButtonTapped), for: .touchUpInside)

        newsLabel.text = "main_page_subtitle2".localized
        newsLabel.font = .systemFont(ofSize: 16, weight: .medium)
        newsLabel.numberOfLines = 0
        newsLabel.textAlignment = .left
        newsLabel.textColor = .systemMint

        newsButton.setTitle("main_page_news_button".localized, for: .normal)
        newsButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        newsButton.setTitleColor(.systemMint, for: .normal)
        newsButton.layer.cornerRadius = 15
        newsButton.layer.borderWidth = 1
        newsButton.layer.borderColor = UIColor.systemMint.cgColor
        newsButton.addTarget(self, action: #selector(newsUpButtonTapped), for: .touchUpInside)

        [titleLabel, ratesLabel, ratesButton, newsLabel, newsButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }


    private func setupConstraintsSnapKit() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalTo(view).inset(20)
        }

        ratesLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(80)
            $0.leading.trailing.equalTo(view).inset(40)
        }

        ratesButton.snp.makeConstraints {
            $0.top.equalTo(ratesLabel.snp.bottom).offset(40)
            $0.centerX.equalTo(view)
            $0.size.equalTo(CGSize(width: 160, height: 50))
        }

        newsLabel.snp.makeConstraints {
            $0.top.equalTo(ratesButton.snp.bottom).offset(80)
            $0.leading.trailing.equalTo(view).inset(40)
        }

        newsButton.snp.makeConstraints {
            $0.top.equalTo(newsLabel.snp.bottom).offset(40)
            $0.centerX.equalTo(view)
            $0.size.equalTo(CGSize(width: 160, height: 50))
        }
    }

    // MARK: - Actions

    @objc private func ratesButtonTapped() {
//        fatalError()
        presenter?.exchangeRatesDidTapped()

        Analytics.logEvent("Главный_экран", parameters: ["Нажал на кнопку просмотра курсов валют": true])
    }

    @objc private func newsUpButtonTapped() {
//        fatalError()
        presenter?.newsDidTapped()

        Analytics.logEvent("Главный_экран", parameters: ["Нажал на кнопку просмотра новостей": true])
    }
}
