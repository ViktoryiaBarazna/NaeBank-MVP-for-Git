//
//  ExchangeRatesMainViewController.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 26.04.26.
//

import UIKit
import SnapKit

final class ExchangeRatesMainViewController: UIViewController {

    // MARK: - MVP
    var presenter: ExchangeRatesPresenterProtocol?

    // MARK: - Subviews
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let tableView = UITableView()
    private let errorLabel = UILabel()

    // MARK: Data
    private var displayedCellViewModels: [ExchangeRatesCellViewModel] = []
    private var allRates: [ExchangeRatesAPIModel] = []

    // MARK: - Build
    static func build() -> UIViewController {
        let service = NetworkRatesService()
        let router = ExchangeRatesRouter()
        let presenter = ExchangeRatesPresenter(service: service, router: router)
        let vc = ExchangeRatesMainViewController()

        presenter.view = vc
        router.viewController = vc
        vc.presenter = presenter

        return vc
    }

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultBackground()
        setupViewProperties()
        setupSubViews()
        //        setupConstraints()
        setupConstraintsSnapKit()

        // Автоматическая загрузка данных при запуске
        presenter?.viewDidLoad()
    }

    // MARK: - Layout
    private func setupViewProperties() {

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.systemPurple, .font: UIFont.boldSystemFont(ofSize: 30),
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .systemBlue
    }

    private func setupSubViews() {

        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .systemPurple
        activityIndicator.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.7)
        activityIndicator.layer.cornerRadius = 10

        tableView.register(ExchangeRatesCell.self, forCellReuseIdentifier: "RatesInfoCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .systemBackground

        errorLabel.font = .systemFont(ofSize: 18, weight: .medium)
        errorLabel.textColor = .systemRed
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        [activityIndicator, tableView, errorLabel].forEach { view.addSubview($0) }
    }

//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//
//            activityIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            errorLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 40),
//            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
//        ])
//    }

    private func setupConstraintsSnapKit() {
        activityIndicator.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalTo(view)
        }

        errorLabel.snp.makeConstraints {
            $0.top.equalTo(activityIndicator.snp.bottom).offset(40)
            $0.leading.trailing.equalTo(view).inset(20)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.leading.trailing.equalTo(view).inset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
}

// MARK: - ExchangeRatesViewProtocol (протокол — контракт с Presenter)
extension ExchangeRatesMainViewController: ExchangeRatesViewProtocol {

    func showContent(_ viewModel: ExchangeRatesViewModel) {
        title = viewModel.title
        displayedCellViewModels = viewModel.cellViewModels
        allRates = viewModel.rates
        tableView.reloadData()

        if let errorMessage = viewModel.errorMessage {
            errorLabel.text = "❌ \(errorMessage)"
            errorLabel.isHidden = false
            tableView.isHidden = true
        } else {
            errorLabel.isHidden = true
            tableView.isHidden = false
        }
    }

    func showLoading() {
        activityIndicator.startAnimating()
        tableView.isHidden = true
        errorLabel.isHidden = true
    }

    func hideLoading() { activityIndicator.stopAnimating() }
}

// MARK: - UITableViewDataSource
extension ExchangeRatesMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "RatesInfoCell", for: indexPath) as? ExchangeRatesCell
        else { return UITableViewCell() }

        let viewModel = displayedCellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ExchangeRatesMainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectRate(at: indexPath.row)
    }
}
