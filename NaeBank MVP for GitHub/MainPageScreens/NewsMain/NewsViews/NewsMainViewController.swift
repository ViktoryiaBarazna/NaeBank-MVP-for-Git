//
//  NewsMainViewController.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 26.04.26.
//

import UIKit
import SnapKit

final class NewsMainViewController: UIViewController {

    // MARK: - MVP
    var presenter: NewsPresenterProtocol?

    // MARK: - Subviews
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let tableView = UITableView()
    private let errorLabel = UILabel()

    // MARK: Data
    private var displayedCellViewModels: [NewsCellViewModel] = []
    private var allNews: [NewsAPIModel] = []

    // MARK: - Build
    static func build() -> UIViewController {

        let service = NetworkNewsService()
        let router = NewsRouter()
        let presenter = NewsPresenter(service: service, router: router)
        let vc = NewsMainViewController()

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
            .foregroundColor: UIColor.systemMint, .font: UIFont.boldSystemFont(ofSize: 30),
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .systemBlue
    }

    private func setupSubViews() {

        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .systemMint
        activityIndicator.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.7)
        activityIndicator.layer.cornerRadius = 10

        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
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

        [activityIndicator, tableView, errorLabel].forEach {
            view.addSubview($0)
        }
    }


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

// MARK: -
extension NewsMainViewController: NewsViewProtocol {

    func showContent(_ viewModel: NewsViewModel) {
        title = viewModel.title
        displayedCellViewModels = viewModel.newsCellViewModels
        allNews = viewModel.news
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
extension NewsMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)
                as? NewsCell
        else { return UITableViewCell() }

        let news = displayedCellViewModels[indexPath.row]
        cell.configure(with: news)
        return cell
    }
}

// MARK: - UITableViewDelegate (переход на отдельный экран)
extension NewsMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectNews(at: indexPath.row)
    }
}
