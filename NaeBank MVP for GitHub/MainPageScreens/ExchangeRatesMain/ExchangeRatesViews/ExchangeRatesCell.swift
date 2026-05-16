//
//  RatesInfoCell.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 26.04.26.
//

import UIKit
import SnapKit

final class ExchangeRatesCell: UITableViewCell {

    // MARK: - Subviews
    private let avatarImageView = UIImageView()
    private let departmentNameLabel = UILabel()
    private let cityNameLabel = UILabel()
    private let containerView = UIView()
    private let horizontalStackView = UIStackView()

    // MARK: Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
//        setupConstraints()
        setupConstraintsSnapKit()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Layout
    private func setupSubviews() {
        backgroundColor = .clear
        selectionStyle = .none

        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.tintColor = .systemMint
        chevronImageView.sizeToFit()
        accessoryView = chevronImageView

        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemMint.cgColor

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 10
        avatarImageView.image = UIImage(systemName: "house.fill")
        avatarImageView.tintColor = .systemMint
        avatarImageView.backgroundColor = .systemBackground

        departmentNameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        departmentNameLabel.numberOfLines = 0
        departmentNameLabel.textColor = .label

        cityNameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        cityNameLabel.numberOfLines = 0
        cityNameLabel.textColor = .secondaryLabel

        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 12
        horizontalStackView.alignment = .center
        horizontalStackView.distribution = .equalSpacing

        [avatarImageView, departmentNameLabel, cityNameLabel].forEach {
            horizontalStackView.addArrangedSubview($0)
        }

        containerView.addSubview(horizontalStackView)
        contentView.addSubview(containerView)
    }

//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
//
//            horizontalStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
//            horizontalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
//            horizontalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
//            horizontalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
//
//            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
//            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
//        ])
//    }

    private func setupConstraintsSnapKit() {

        containerView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView).inset(8)
            $0.leading.trailing.equalTo(contentView).inset(16)
        }

        horizontalStackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(containerView).inset(12)
        }

        avatarImageView.snp.makeConstraints {
            $0.size.equalTo(50)
        }
    }

    func configure(with viewModel: ExchangeRatesCellViewModel) {
        departmentNameLabel.text = viewModel.departmentName
        cityNameLabel.text = "📍 \(viewModel.cityName)"
    }
}
