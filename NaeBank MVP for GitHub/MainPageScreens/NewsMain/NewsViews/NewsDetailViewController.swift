//
//  NewsDetailViewController.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 26.04.26.
//

import UIKit
import SnapKit

final class NewsDetailViewController: UIViewController {

    // MARK: - Subviews
    private let news: NewsAPIModel
    private let imageLoader: ImageLoadingServiceProtocol
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()

    static func build(
        news: NewsAPIModel, imageLoader: ImageLoadingServiceProtocol = ImageLoadingService.shared
    ) -> UIViewController { NewsDetailViewController(news: news, imageLoader: imageLoader) }

    init(news: NewsAPIModel, imageLoader: ImageLoadingServiceProtocol) {
        self.news = news
        self.imageLoader = imageLoader
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

        addLabel(text: "📰 \(news.name_ru)", fontSize: 22, isBold: true)
        addLabel(text: "📅 \(news.start_date)", fontSize: 14)

        if let url = URL(string: news.img), !news.img.isEmpty {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            stackView.addArrangedSubview(imageView)
            imageView.snp.makeConstraints {
                $0.height.equalTo(200)
            }

            imageLoader.loadImage(from: url) { image in
                DispatchQueue.main.async { imageView.image = image }
            }
        }

        addSeparator()

        // Текст новости
        let cleanText = news.html_ru.replacingOccurrences(
            of: "<[^>]+>", with: "", options: .regularExpression)
        addLabel(text: cleanText, fontSize: 16)
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
