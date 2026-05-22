//
//  OnboardingViewController.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 29.03.26.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {

    // MARK: - MVP
    var presenter: OnboardingPresenterProtocol?

    // MARK: - Subviews
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let greetingTitleLabel = UILabel()
    private let descriptionTitleLabel = UILabel()
    private let imageView = UIImageView()
    private let functionDescriptionLabel = UILabel()
    private let loginButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)
    private let footerLabel = UILabel()

    private let stackView = UIStackView()

    // MARK: - Build
    static func build() -> UIViewController {
        let router = OnboardingRouter()
        let presenter = OnboardingPresenter(router: router)
        let vc = OnboardingViewController()

        router.viewController = vc
        vc.presenter = presenter

        return vc
    }

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDefaultBackground()
        setupSubViews()
        setupConstraintsSnapKit()
        attributedGreetingTitleLabel()
    }

    // MARK: - Layout

    private func setupSubViews() {

        greetingTitleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        greetingTitleLabel.textColor = .systemPurple
        greetingTitleLabel.textAlignment = .center
        greetingTitleLabel.numberOfLines = 0

        descriptionTitleLabel.text = "onboarding_descr_subtitle1".localized
        descriptionTitleLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionTitleLabel.textColor = .secondaryLabel
        descriptionTitleLabel.textAlignment = .center
        descriptionTitleLabel.numberOfLines = 0

        imageView.image = UIImage(named: "start_logo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true

        functionDescriptionLabel.text = "onboarding_descr_subtitle2".localized
        functionDescriptionLabel.font = UIFont.systemFont(ofSize: 12)
        functionDescriptionLabel.textColor = .secondaryLabel
        functionDescriptionLabel.textAlignment = .center
        functionDescriptionLabel.numberOfLines = 0

        loginButton.setTitle("login_button".localized, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        loginButton.backgroundColor = .systemPurple
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 15
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        registerButton.setTitle("register_button".localized, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        registerButton.setTitleColor(.systemMint, for: .normal)
        registerButton.layer.cornerRadius = 15
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.systemMint.cgColor
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)

        footerLabel.text = "onboarding_footer_title".localized
        footerLabel.font = UIFont.systemFont(ofSize: 10)
        footerLabel.textColor = .tertiaryLabel
        footerLabel.textAlignment = .center
        footerLabel.numberOfLines = 0

        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.distribution = .fill

        // Добавляем в stackView все элементы, кроме footerLabel
        [
            greetingTitleLabel, descriptionTitleLabel, imageView, functionDescriptionLabel, loginButton, registerButton
        ].forEach { stackView.addArrangedSubview($0) }

        [scrollView, contentView, stackView, footerLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        view.addSubview(footerLabel)
    }


    private func setupConstraintsSnapKit() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view)
            $0.bottom.equalTo(footerLabel.snp.top).offset(-20)
        }

        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.leading.trailing.equalTo(contentView).inset(30)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }

        imageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 200, height: 325))
        }

        loginButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 180, height: 50))
        }

        registerButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 180, height: 50))
        }

        footerLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }

    private func attributedGreetingTitleLabel() {
        let text = "onboarding_title".localized
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttribute(
            .foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: 16))
        attributed.addAttribute(
            .foregroundColor, value: UIColor.systemPurple,
            range: NSRange(location: 16, length: text.count - 16))
        greetingTitleLabel.attributedText = attributed
    }

    // MARK: - Actions
    @objc private func loginButtonTapped() {
        presenter?.loginButtonDidTapped()
    }

    @objc private func registerButtonTapped() {
        presenter?.registerButtonDidTapped()
    }
}
