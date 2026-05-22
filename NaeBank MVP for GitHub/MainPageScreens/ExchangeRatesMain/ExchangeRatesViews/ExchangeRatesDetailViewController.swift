//
//  ExchangeRatesDetailViewController.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 26.04.26.
//

import UIKit
import SnapKit

final class ExchangeRatesDetailViewController: UIViewController {

    static func build(department: ExchangeRatesAPIModel) -> UIViewController {
        ExchangeRatesDetailViewController(department: department)
    }

    // MARK: - Subviews
    private let department: ExchangeRatesAPIModel
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()

    init(department: ExchangeRatesAPIModel) {
        self.department = department
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultBackground()
        setupSubViews()
        setupConstraintsSnapKit()

        fillData()
    }

    // MARK: - Layout

    private func setupSubViews() {

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
    }


    private func setupConstraintsSnapKit() {
        scrollView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view)
        }

        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.width.equalTo(scrollView)
        }

        stackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(contentView).inset(20)
        }
    }

    private func fillData() {
        // Информация об отделении
        stackView.addLabel(text: "🏦 \(department.filials_text)", fontSize: 18, isBold: true)
        stackView.addLabel(
            text: "📍 \(department.name) \(department.street) \(department.home_number)",
            fontSize: 16)
        stackView.addLabel(text: "🕒 \(department.info_worktime)", fontSize: 14)

        stackView.addSeparator()

        // Курсы валют
        stackView.addLabel(text: "exchange_rates_currency_usd".localized, fontSize: 16, isBold: true)
        stackView.addLabel(text: "exchange_rates_buy_currency".localized(department.USD_in, "BYN"), fontSize: 15)
        stackView.addLabel(text: "exchange_rates_sell_currency".localized(department.USD_out, "BYN"), fontSize: 15)

        stackView.addLabel(text: "exchange_rates_currency_euro".localized, fontSize: 16, isBold: true)
        stackView.addLabel(text: "exchange_rates_buy_currency".localized(department.EUR_in, "BYN"), fontSize: 15)
        stackView.addLabel(text: "exchange_rates_sell_currency".localized(department.EUR_out, "BYN"), fontSize: 15)

        stackView.addLabel(text: "exchange_rates_currency_rub".localized, fontSize: 16, isBold: true)
        stackView.addLabel(text: "exchange_rates_buy_currency".localized(department.RUB_in, "BYN"), fontSize: 15)
        stackView.addLabel(text: "exchange_rates_sell_currency".localized(department.RUB_out, "BYN"), fontSize: 15)

        stackView.addLabel(text: "exchange_rates_currency_cny".localized, fontSize: 16, isBold: true)
        stackView.addLabel(text: "exchange_rates_buy_currency".localized(department.CNY_in, "BYN"), fontSize: 15)
        stackView.addLabel(text: "exchange_rates_sell_currency".localized(department.CNY_out, "BYN"), fontSize: 15)
    }

}
