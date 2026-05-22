//
//  NewsCell.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 26.04.26.
//

import UIKit
import SnapKit

final class NewsCell: UITableViewCell {

    // MARK: - Subviews
    private let avatarImageView = UIImageView()
    private let newsNameLabel = UILabel()
    private let newsDateLabel = UILabel()
    private let containerView = UIView()
    private let horizontalStackView = UIStackView()

    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraintsSnapKit()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Layout
    private func setupSubviews() {
        backgroundColor = .clear
        selectionStyle = .none

        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = .systemPurple
        chevronImageView.sizeToFit()
        accessoryView = chevronImageView

        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemPurple.cgColor

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.image = UIImage(systemName: "megaphone.fill")
        avatarImageView.tintColor = .systemPurple
        avatarImageView.backgroundColor = .secondarySystemBackground

        newsNameLabel.font = .systemFont(ofSize: 12, weight: .medium)
        newsNameLabel.numberOfLines = 0
        newsNameLabel.textColor = .label

        newsDateLabel.font = .systemFont(ofSize: 12, weight: .medium)
        newsDateLabel.numberOfLines = 0
        newsNameLabel.textAlignment = .left
        newsDateLabel.textColor = .secondaryLabel

        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 12
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .equalSpacing

        [avatarImageView, newsNameLabel, newsDateLabel].forEach {
            horizontalStackView.addArrangedSubview($0)
        }

        containerView.addSubview(horizontalStackView)
        contentView.addSubview(containerView)
    }


    private func setupConstraintsSnapKit() {
        containerView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView).inset(8)
            $0.leading.trailing.equalTo(contentView).inset(16)
        }

        horizontalStackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(containerView).inset(12)
        }

        avatarImageView.snp.makeConstraints {
            $0.size.equalTo(30)
        }
    }

    func configure(with viewModel: NewsCellViewModel) {
        newsNameLabel.text = viewModel.newsName
        newsDateLabel.text = viewModel.newsDate
    }
}
