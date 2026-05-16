//
//  MainPageViewController.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 1.04.26.
//

import UIKit
import SnapKit

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
//        setupConstraints()
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

//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//
//            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//
//            ratesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
//            ratesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
//            ratesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
//
//            ratesButton.topAnchor.constraint(equalTo: ratesLabel.bottomAnchor, constant: 40),
//            ratesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            ratesButton.heightAnchor.constraint(equalToConstant: 50),
//            ratesButton.widthAnchor.constraint(equalToConstant: 160),
//
//            newsLabel.topAnchor.constraint(equalTo: ratesButton.bottomAnchor, constant: 80),
//            newsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
//            newsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
//
//            newsButton.topAnchor.constraint(equalTo: newsLabel.bottomAnchor, constant: 40),
//            newsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            newsButton.heightAnchor.constraint(equalToConstant: 50),
//            newsButton.widthAnchor.constraint(equalToConstant: 160),
//        ])
//    }

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
        presenter?.exchangeRatesDidTapped()
    }

    @objc private func newsUpButtonTapped() {
        presenter?.newsDidTapped()
    }
}
