//
//  AfterRegisterViewController.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 30.03.26.
//

import UIKit
import SnapKit

final class AfterRegisterViewController: UIViewController {

    // MARK: - MVP
    var presenter: AfterRegisterPresenterProtocol?

    // MARK: - Subviews
    private let label = UILabel()
    private let imageView = UIImageView()
    private let loginButton = UIButton()

    // MARK: Build
    static func build() -> UIViewController {
        let router = AfterRegisterRouter()
        let presenter = AfterRegisterPresenter(router: router)
        let vc = AfterRegisterViewController()

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
        attributedLabel()

        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    // MARK: - Layout

    private func setupSubViews() {
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label

        imageView.image = (UIImage(named: "logo_2"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true

        loginButton.setTitle("login_button".localized, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        loginButton.backgroundColor = .systemPurple
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 15
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        [label, imageView, loginButton].forEach {
            view.addSubview($0)
        }
    }


    private func setupConstraintsSnapKit() {
        label.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.leading.trailing.equalTo(view).inset(20)
        }

        imageView.snp.makeConstraints {
            $0.top.equalTo(label.snp.bottom).offset(40)
            $0.centerX.equalTo(view)
            $0.size.equalTo(CGSize(width: 150, height: 300))
        }

        loginButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(80)
            $0.centerX.equalTo(view)
            $0.size.equalTo(CGSize(width: 220, height: 60))
        }
    }

    private func attributedLabel() {
        let text = "after_register_title".localized
        let attributed = NSMutableAttributedString(string: text)

        attributed.addAttribute(
            .foregroundColor, value: UIColor.systemPurple, range: NSRange(location: 0, length: 13))
        attributed.addAttribute(
            .foregroundColor, value: UIColor.label,
            range: NSRange(location: 13, length: text.count - 13))

        label.attributedText = attributed
    }

    // MARK: - Actions
    @objc private func loginButtonTapped() { presenter?.loginButtonDidTapped() }
}
