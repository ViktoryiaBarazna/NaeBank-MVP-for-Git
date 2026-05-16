//
//  RegisterViewController.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 6.04.26.
//

import UIKit
import SnapKit

final class RegisterViewController: UIViewController {

    // MARK: - MVP
    var presenter: RegisterPresenterProtocol?

    // MARK: - Subviews
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let phoneTitleLabel = UILabel()
    private let phoneTextField = UITextField()
    private let phoneHintLabel = UILabel()
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    private let repeatPasswordLabel = UILabel()
    private let repeatPasswordTextField = UITextField()
    private let termsButton = UIButton(type: .system)
    private var termsAccepted = false
    private let registerButton = UIButton(type: .system)
    private let hasProfileLabel = UILabel()
    private let loginButton = UIButton(type: .system)
    private let securityLabel = UILabel()

    // MARK: - Build
    static func build() -> UIViewController {
        let keychainStore = RegisterKeychainStore()
        let registrationService = RegistrationService(keychain: keychainStore)
        let router = RegisterRouter()
        let presenter = RegisterPresenter(router: router, registrationService: registrationService)
        let vc = RegisterViewController()

        router.viewController = vc
        presenter.view = vc
        vc.presenter = presenter

        return vc
    }

    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomBackground()
        setupSubViews()
        //        setupConstraints()
        setupConstraintsSnapKit()
        atributedTitleLabel()
        setupTextFieldDelegates()
    }

    // MARK: - Layout

    private func setupCustomBackground() {
        view.backgroundColor = .systemBackground
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() { view.endEditing(true) }

    private func setupSubViews() {
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textColor = .systemMint
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left

        subTitleLabel.text = "register_subtitle".localized
        subTitleLabel.font = UIFont.systemFont(ofSize: 12)
        subTitleLabel.textColor = .secondaryLabel
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textAlignment = .left

        phoneTitleLabel.text = "placeholder_phone_number".localized
        phoneTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        phoneTitleLabel.textColor = .secondaryLabel
        phoneTitleLabel.numberOfLines = 0
        phoneTitleLabel.textAlignment = .left

        phoneTextField.placeholder = "+375XXXXXXXXX"
        phoneTextField.textColor = .label
        phoneTextField.backgroundColor = .secondarySystemBackground
        phoneTextField.keyboardType = .phonePad
        phoneTextField.font = UIFont.systemFont(ofSize: 14)
        phoneTextField.layer.cornerRadius = 15
        phoneTextField.layer.borderWidth = 1
        phoneTextField.layer.borderColor = UIColor.systemMint.cgColor
        phoneTextField.autocorrectionType = .no
        phoneTextField.autocapitalizationType = .none

        phoneHintLabel.text = "register_phone_descr".localized
        phoneHintLabel.font = UIFont.systemFont(ofSize: 11, weight: .light)
        phoneHintLabel.textColor = .tertiaryLabel
        phoneHintLabel.numberOfLines = 0
        phoneHintLabel.textAlignment = .left

        passwordLabel.text = "placeholder_password".localized
        passwordLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        passwordLabel.textColor = .secondaryLabel
        passwordLabel.numberOfLines = 0
        passwordLabel.textAlignment = .left

        passwordTextField.placeholder = "register_password_descr".localized
        passwordTextField.textColor = .label
        passwordTextField.backgroundColor = .secondarySystemBackground
        passwordTextField.font = UIFont.systemFont(ofSize: 14)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .next
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.layer.cornerRadius = 15
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.systemMint.cgColor

        repeatPasswordLabel.text = "register_repeat_password".localized
        repeatPasswordLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        repeatPasswordLabel.textColor = .secondaryLabel
        repeatPasswordLabel.numberOfLines = 0
        repeatPasswordLabel.textAlignment = .left

        repeatPasswordTextField.placeholder = "register_repeat_password_descr".localized
        repeatPasswordTextField.textColor = .label
        repeatPasswordTextField.backgroundColor = .secondarySystemBackground
        repeatPasswordTextField.font = UIFont.systemFont(ofSize: 14)
        repeatPasswordTextField.isSecureTextEntry = true
        repeatPasswordTextField.returnKeyType = .done
        repeatPasswordTextField.clearButtonMode = .whileEditing
        repeatPasswordTextField.layer.cornerRadius = 15
        repeatPasswordTextField.layer.borderWidth = 1
        repeatPasswordTextField.layer.borderColor = UIColor.systemMint.cgColor

        updateTermsButtonTitle()
        termsButton.titleLabel?.font = .systemFont(ofSize: 12)
        termsButton.titleLabel?.numberOfLines = 0
        termsButton.titleLabel?.textAlignment = .left
        termsButton.setTitleColor(.secondaryLabel, for: .normal)
        termsButton.addTarget(self, action: #selector(toggleTerms), for: .touchUpInside)

        registerButton.setTitle("register_button".localized, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        registerButton.backgroundColor = .systemMint
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 15
        registerButton.layer.borderWidth = 0
        registerButton.layer.shadowOpacity = 0
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)

        hasProfileLabel.text = "register_have_profile".localized
        hasProfileLabel.font = .systemFont(ofSize: 12)
        hasProfileLabel.textColor = .secondaryLabel
        hasProfileLabel.textAlignment = .center

        loginButton.setTitle("login_button".localized, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        loginButton.setTitleColor(.systemMint, for: .normal)
        loginButton.backgroundColor = .clear
        loginButton.layer.cornerRadius = 15
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.systemMint.cgColor
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        securityLabel.text = "AES-256 BANK GRADE SECURITY"
        securityLabel.font = .systemFont(ofSize: 10)
        securityLabel.textColor = .secondaryLabel
        securityLabel.textAlignment = .center

        addLeftIcon(textField: phoneTextField, iconName: "phone")
        addLeftIcon(textField: passwordTextField, iconName: "lock")
        addLeftIcon(textField: repeatPasswordTextField, iconName: "lock")

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(securityLabel)

        [titleLabel, subTitleLabel, phoneTitleLabel, phoneTextField, phoneHintLabel,
         passwordLabel, passwordTextField, repeatPasswordLabel, repeatPasswordTextField,
         termsButton, registerButton, hasProfileLabel, loginButton,
        ].forEach {
            contentView.addSubview($0)
        }
    }

//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: securityLabel.topAnchor, constant: -20),
//
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//
//            securityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            securityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            securityLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
//
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//
//            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
//            subTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            subTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//
//            phoneTitleLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 40),
//            phoneTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            phoneTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//
//            phoneTextField.topAnchor.constraint(equalTo: phoneTitleLabel.bottomAnchor, constant: 10),
//            phoneTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            phoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            phoneTextField.heightAnchor.constraint(equalToConstant: 50),
//
//            phoneHintLabel.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 10),
//            phoneHintLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            phoneHintLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//
//            passwordLabel.topAnchor.constraint(equalTo: phoneHintLabel.bottomAnchor, constant: 20),
//            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            passwordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//
//            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
//            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
//
//            repeatPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
//            repeatPasswordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            repeatPasswordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//
//            repeatPasswordTextField.topAnchor.constraint(equalTo: repeatPasswordLabel.bottomAnchor, constant: 10),
//            repeatPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            repeatPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
//
//            termsButton.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 10),
//            termsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            termsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//
//            registerButton.topAnchor.constraint(equalTo: termsButton.bottomAnchor, constant: 20),
//            registerButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            registerButton.heightAnchor.constraint(equalToConstant: 60),
//            registerButton.widthAnchor.constraint(equalToConstant: 220),
//
//            hasProfileLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20),
//            hasProfileLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            hasProfileLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//
//            loginButton.topAnchor.constraint(equalTo: hasProfileLabel.bottomAnchor, constant: 10),
//            loginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            loginButton.heightAnchor.constraint(equalToConstant: 60),
//            loginButton.widthAnchor.constraint(equalToConstant: 220),
//            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
//        ])
//    }

    private func setupConstraintsSnapKit() {

        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view)
            $0.bottom.equalTo(securityLabel.snp.top).offset(-20)
        }

        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.width.equalTo(scrollView)
        }

        securityLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(view).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }

        phoneTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }

        phoneTextField.snp.makeConstraints {
            $0.top.equalTo(phoneTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.height.equalTo(50)
        }

        phoneHintLabel.snp.makeConstraints {
            $0.top.equalTo(phoneTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }

        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(phoneHintLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }

        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.height.equalTo(50)
        }

        repeatPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }

        repeatPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(repeatPasswordLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.height.equalTo(50)
        }

        termsButton.snp.makeConstraints {
            $0.top.equalTo(repeatPasswordTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }

        registerButton.snp.makeConstraints {
            $0.top.equalTo(termsButton.snp.bottom).offset(20)
            $0.centerX.equalTo(contentView)
            $0.size.equalTo(CGSize(width: 220, height: 60))
        }

        hasProfileLabel.snp.makeConstraints {
            $0.top.equalTo(registerButton.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }

        loginButton.snp.makeConstraints {
            $0.top.equalTo(hasProfileLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(contentView)
            $0.size.equalTo(CGSize(width: 220, height: 60))
            $0.bottom.equalTo(contentView).offset(-20)
        }
    }

    private func atributedTitleLabel() {
        let text = "register_title".localized
        let attributed = NSMutableAttributedString(string: text)
        attributed.addAttribute(
            .foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: 8))
        attributed.addAttribute(
            .foregroundColor, value: UIColor.systemMint,
            range: NSRange(location: 8, length: text.count - 8))
        titleLabel.attributedText = attributed
    }

    private func addLeftIcon(textField: UITextField, iconName: String) {
        let iconImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconImageView.image = UIImage(systemName: iconName)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemMint

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        view.isUserInteractionEnabled = false
        view.addSubview(iconImageView)

        textField.leftView = view
        textField.leftViewMode = .always
    }

    private func setupTextFieldDelegates() {
        phoneTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
    }

    // MARK: - Actions

    @objc private func registerButtonTapped() {
        presenter?.registerTapped(
            phone: phoneTextField.text, password: passwordTextField.text,
            repeatPassword: repeatPasswordTextField.text, termsAccepted: termsAccepted)
    }

    @objc private func loginButtonTapped() { presenter?.loginButtonDidTapped() }

    @objc private func toggleTerms() {
        termsAccepted.toggle()
        updateTermsButtonTitle()
    }

    private func updateTermsButtonTitle() {
        let mark = termsAccepted ? "☑" : "☐"
        termsButton.setTitle("\(mark) " + "register_terms".localized, for: .normal)
    }
}

// MARK: - RegisterViewProtocol
extension RegisterViewController: RegisterViewProtocol {

    func resetInvalidFieldHighlighting() {
        [phoneTextField, passwordTextField, repeatPasswordTextField].forEach { field in
            field.layer.borderColor = UIColor.systemMint.cgColor
            field.layer.borderWidth = 1.0
        }
        termsButton.layer.borderWidth = 0
        termsButton.layer.borderColor = UIColor.clear.cgColor
    }

    func showInvalidFields(_ invalid: RegisterInvalidFields) {
        if invalid.phone {
            phoneTextField.layer.borderColor = UIColor.systemRed.cgColor
            phoneTextField.layer.borderWidth = 2.0
        }
        if invalid.password {
            passwordTextField.layer.borderColor = UIColor.systemRed.cgColor
            passwordTextField.layer.borderWidth = 2.0
        }
        if invalid.repeatPassword {
            repeatPasswordTextField.layer.borderColor = UIColor.systemRed.cgColor
            repeatPasswordTextField.layer.borderWidth = 2.0
        }
        if invalid.terms {
            termsButton.layer.borderWidth = 1.0
            termsButton.layer.borderColor = UIColor.systemRed.cgColor
            termsButton.layer.cornerRadius = 8
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func applyTrimmedPhone(_ phone: String) { phoneTextField.text = phone }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if textField == phoneTextField {
            if string.isEmpty { return true }
            guard let currentText = textField.text as NSString? else { return true }
            let newText = currentText.replacingCharacters(in: range, with: string)
            return newText.count <= 13
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            repeatPasswordTextField.becomeFirstResponder()
        } else if textField == repeatPasswordTextField {
            textField.resignFirstResponder()
            registerButtonTapped()
        }
        return true
    }
}
