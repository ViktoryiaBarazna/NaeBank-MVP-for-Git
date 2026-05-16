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
        //        setupConstraints()
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

//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//
//            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
//            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
//        ])
//    }

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
        addLabel(text: "🏦 \(department.filials_text)", fontSize: 18, isBold: true)
        addLabel(
            text: "📍 \(department.name) \(department.street) \(department.home_number)",
            fontSize: 16)
        addLabel(text: "🕒 \(department.info_worktime)", fontSize: 14)

        addSeparator()

        // Курсы валют
        addLabel(text: "exchange_rates_currency_usd".localized, fontSize: 16, isBold: true)
        addLabel(text: "exchange_rates_buy_currency".localized(department.USD_in, "BYN"), fontSize: 15)
        addLabel(text: "exchange_rates_sell_currency".localized(department.USD_out, "BYN"), fontSize: 15)

        addLabel(text: "exchange_rates_currency_euro".localized, fontSize: 16, isBold: true)
        addLabel(text: "exchange_rates_buy_currency".localized(department.EUR_in, "BYN"), fontSize: 15)
        addLabel(text: "exchange_rates_sell_currency".localized(department.EUR_out, "BYN"), fontSize: 15)

        addLabel(text: "exchange_rates_currency_rub".localized, fontSize: 16, isBold: true)
        addLabel(text: "exchange_rates_buy_currency".localized(department.RUB_in, "BYN"), fontSize: 15)
        addLabel(text: "exchange_rates_sell_currency".localized(department.RUB_out, "BYN"), fontSize: 15)

        addLabel(text: "exchange_rates_currency_cny".localized, fontSize: 16, isBold: true)
        addLabel(text: "exchange_rates_buy_currency".localized(department.CNY_in, "BYN"), fontSize: 15)
        addLabel(text: "exchange_rates_sell_currency".localized(department.CNY_out, "BYN"), fontSize: 15)
    }

    private func addLabel(text: String, fontSize: CGFloat, isBold: Bool = false) {
        let label = UILabel()
        label.text = text
        label.textColor = .label
        label.numberOfLines = 0
        label.font = isBold ? .boldSystemFont(ofSize: fontSize) : .systemFont(ofSize: fontSize)
        stackView.addArrangedSubview(label)
    }

    private func addSeparator() {
        let line = UIView()
        line.backgroundColor = .separator
        stackView.addArrangedSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }

}
