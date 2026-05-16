//
//  NewsPresenter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 4.05.26.
//

import Foundation

final class NewsPresenter: NewsPresenterProtocol {

    weak var view: NewsViewProtocol?
    var router: NewsRouterProtocol
    private let service: NewsServiceProtocol
    private var news: [NewsAPIModel] = []

    init(service: NewsServiceProtocol, router: NewsRouterProtocol) {
        self.service = service
        self.router = router
    }

    func viewDidLoad() { fetchNews() }

    func didSelectNews(at index: Int) {
        guard index < news.count else { return }
        router.openDetails(for: news[index])
    }

    private func fetchNews() {

        view?.showLoading()

        service.fetchNews { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()

                switch result {
                case .success(let news):
                    self?.news = news

                    // Трансформируем Model в ViewModel для таблицы
                    let newsCellViewModels = news.map { NewsCellViewModel(from: $0) }

                    let viewModel = NewsViewModel(
                        news: news, newsCellViewModels: newsCellViewModels, title: "news_title".localized,
                        errorMessage: nil)

                    self?.view?.showContent(viewModel)

                case .failure(let error):
                    let viewModel = NewsViewModel(
                        news: [], newsCellViewModels: [], title: "news_error".localized,
                        errorMessage: error.localizedDescription)
                    self?.view?.showContent(viewModel)
                }
            }
        }
    }
}
