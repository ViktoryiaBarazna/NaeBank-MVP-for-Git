//
//  ExchangeRatesPresenter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 3.05.26.
//

import Foundation

final class ExchangeRatesPresenter: ExchangeRatesPresenterProtocol {

    weak var view: ExchangeRatesViewProtocol?
    var router: ExchangeRatesRouterProtocol
    private let service: ExchangeRatesServiceProtocol
    private var rates: [ExchangeRatesAPIModel] = []

    init(service: ExchangeRatesServiceProtocol, router: ExchangeRatesRouterProtocol) {
        self.service = service
        self.router = router
    }

    func viewDidLoad() { fetchRates() }

    func didSelectRate(at index: Int) {
        guard index < rates.count else { return }
        router.openDetails(for: rates[index])
    }

    private func fetchRates() {
        view?.showLoading()

        service.fetchRates { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()

                switch result {
                case .success(let rates):
                    self?.rates = rates

                    // Трансформируем Model в ViewModel для таблицы
                    let cellViewModels = rates.map { ExchangeRatesCellViewModel(from: $0) }

                    let viewModel = ExchangeRatesViewModel(
                        rates: rates, cellViewModels: cellViewModels, title: "exchange_rates_title".localized,
                        errorMessage: nil)

                    self?.view?.showContent(viewModel)

                case .failure(let error):
                    let viewModel = ExchangeRatesViewModel(
                        rates: [], cellViewModels: [], title: "exchange_rates_error".localized,
                        errorMessage: error.localizedDescription)
                    self?.view?.showContent(viewModel)
                }
            }
        }
    }
}
