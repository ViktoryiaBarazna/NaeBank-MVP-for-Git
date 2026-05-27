//
//  LoginViewController.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 29.03.26.
//

import UIKit
import SnapKit
import GoogleSignIn

final class LoginViewController: UIViewController {
    
    // MARK: - MVP
    var presenter: LoginPresenterProtocol?
    
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
    private let passwordHintLabel = UILabel()
    private let loginButton = UIButton(type: .system)
    private let googleTitleLabel = UILabel()
    private let googleButton = GIDSignInButton()
    private let registerButton = UIButton(type: .system)
    private let securityLabel = UILabel()
    private let pciDSSLabel = UILabel()
    private let securityStack = UIStackView()

    // MARK: - Build
    static func build() -> UIViewController {
        let keychainStore = LoginKeychainStore()
        let loginService = LoginService(keychain: keychainStore)
        let googleAuthService = GoogleAuthService()
        let router = LoginRouter()
        let presenter = LoginPresenter(
            router: router,
            loginService: loginService,
            googleAuthService: googleAuthService)
        let vc = LoginViewController()
        
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
        setupConstraintsSnapKit()
        setupTextFieldDelegate()
    }

    // MARK: - Layout
    private func setupCustomBackground() {
        setupDefaultBackground()
        setupDismissKeyboardOnTap()
    }

    private func setupSubViews() {
        titleLabel.text = "login_title".localized
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .systemPurple
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        
        subTitleLabel.text = "login_subtitle".localized
        subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        subTitleLabel.textColor = .secondaryLabel
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textAlignment = .left
        
        phoneTitleLabel.text = "placeholder_phone_number".localized
        phoneTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        phoneTitleLabel.textColor = .secondaryLabel
        phoneTitleLabel.numberOfLines = 0
        phoneTitleLabel.textAlignment = .left
        
        phoneTextField.placeholder = "   +375XXXXXXXXX"
        phoneTextField.textColor = .label
        phoneTextField.backgroundColor = .secondarySystemBackground
        phoneTextField.keyboardType = .phonePad
        phoneTextField.font = UIFont.systemFont(ofSize: 16)
        phoneTextField.layer.cornerRadius = 15
        phoneTextField.layer.borderWidth = 1
        phoneTextField.layer.borderColor = UIColor.systemPurple.cgColor
        phoneTextField.clearButtonMode = .whileEditing
        
        phoneHintLabel.text = "login_phone_descr".localized
        phoneHintLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        phoneHintLabel.textColor = .tertiaryLabel
        phoneHintLabel.numberOfLines = 0
        phoneHintLabel.textAlignment = .left
        
        passwordLabel.text = "placeholder_password".localized
        passwordLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        passwordLabel.textColor = .secondaryLabel
        passwordLabel.numberOfLines = 0
        passwordLabel.textAlignment = .left
        
        passwordTextField.placeholder = "login_password_descr1".localized
        passwordTextField.textColor = .label
        passwordTextField.backgroundColor = .secondarySystemBackground
        passwordTextField.font = UIFont.systemFont(ofSize: 16)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .next
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.layer.cornerRadius = 15
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.systemPurple.cgColor
        
        passwordHintLabel.text = "login_password_descr2".localized
        passwordHintLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        passwordHintLabel.textColor = .tertiaryLabel
        passwordHintLabel.numberOfLines = 0
        passwordHintLabel.textAlignment = .left
        
        loginButton.setTitle("login_button".localized, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        loginButton.backgroundColor = .systemPurple
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 15
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        googleTitleLabel.text = "login_with_google".localized
        googleTitleLabel.font = UIFont.systemFont(ofSize: 12)
        googleTitleLabel.textColor = .secondaryLabel
        googleTitleLabel.numberOfLines = 0
        googleTitleLabel.textAlignment = .center

        googleButton.style = .iconOnly
        googleButton.colorScheme = .light
        googleButton.layer.cornerRadius = 24
        googleButton.layer.masksToBounds = true
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        
        registerButton.setTitle("register_button".localized, for: .normal)
        registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        registerButton.setTitleColor(.systemPurple, for: .normal)
        registerButton.backgroundColor = .clear
        registerButton.layer.cornerRadius = 15
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.systemPurple.cgColor
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        securityLabel.text = "login_footer".localized
        securityLabel.font = .systemFont(ofSize: 10)
        securityLabel.textColor = .secondaryLabel
        
        pciDSSLabel.text = "PCI DSS ISO 27001"
        pciDSSLabel.font = .systemFont(ofSize: 10)
        pciDSSLabel.textColor = .secondaryLabel
        
        securityStack.axis = .vertical
        securityStack.spacing = 8
        securityStack.alignment = .center
        securityStack.distribution = .equalSpacing
        
        phoneTextField.setLeftIcon(systemName: "phone", tintColor: .systemPurple)
        passwordTextField.setLeftIcon(systemName: "lock", tintColor: .systemPurple)
        
        [scrollView, contentView, securityStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(securityStack)
        
        [titleLabel, subTitleLabel, phoneTitleLabel, phoneTextField, phoneHintLabel,
         passwordLabel, passwordTextField, passwordHintLabel, loginButton, googleTitleLabel, googleButton,
         registerButton,
        ].forEach {
            contentView.addSubview($0)
        }
        
        [securityLabel, pciDSSLabel].forEach {
            securityStack.addArrangedSubview($0)
        }
    }
    
    
    private func setupConstraintsSnapKit() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view)
            $0.bottom.equalTo(securityStack.snp.top).offset(-20)
        }
        
        contentView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.width.equalTo(scrollView)
        }
        
        securityStack.snp.makeConstraints {
            $0.leading.trailing.equalTo(view).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(40)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }
        
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }
        
        
        phoneTitleLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(70)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }
        
        
        phoneTextField.snp.makeConstraints {
            $0.top.equalTo(phoneTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.height.equalTo(60)
        }
        
        
        phoneHintLabel.snp.makeConstraints {
            $0.top.equalTo(phoneTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }

        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(phoneHintLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.height.equalTo(60)
        }
        
        passwordHintLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }

        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordHintLabel.snp.bottom).offset(50)
            $0.centerX.equalTo(contentView)
            $0.size.equalTo(CGSize(width: 220, height: 60))
        }

        googleTitleLabel.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(contentView).inset(20)
        }

        googleButton.snp.makeConstraints {
            $0.top.equalTo(googleTitleLabel.snp.bottom).offset(8)
            $0.centerX.equalTo(contentView)
            $0.size.equalTo(48)
        }

        registerButton.snp.makeConstraints {
            $0.top.equalTo(googleButton.snp.bottom).offset(30)
            $0.centerX.equalTo(contentView)
            $0.size.equalTo(CGSize(width: 220, height: 60))
            $0.bottom.equalTo(contentView).offset(-20)
        }
    }

    private func setupTextFieldDelegate() {
        phoneTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - Actions
    @objc private func loginButtonTapped() {
        presenter?.loginButtonDidTapped(
            phone: phoneTextField.text, password: passwordTextField.text)
    }
    
    @objc private func googleButtonTapped() {
        presenter?.googleButtonTapped(presentingViewController: self)
    }

    @objc private func registerButtonTapped() {
        presenter?.registerButtonDidTapped()
    }
}

// MARK: - LoginViewProtocol
extension LoginViewController: LoginViewProtocol {
    
    func resetInvalidFieldHighlighting() {
        phoneTextField.layer.borderColor = UIColor.systemPurple.cgColor
        phoneTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor.systemPurple.cgColor
        passwordTextField.layer.borderWidth = 1.0
    }
    
    func showInvalidFields(_ invalid: LoginInvalidFields) {
        if invalid.phone {
            phoneTextField.layer.borderColor = UIColor.systemRed.cgColor
            phoneTextField.layer.borderWidth = 2.0
        }
        if invalid.password {
            passwordTextField.layer.borderColor = UIColor.systemRed.cgColor
            passwordTextField.layer.borderWidth = 2.0
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func applyTrimmedPhone(_ phone: String) { phoneTextField.text = phone }
    
    func clearPasswordField() { passwordTextField.text = "" }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField, shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if textField == phoneTextField {
            // Удаление всегда разрешаем: иначе при длине > 13 (вставка, автозаполнение)
            // условие newText.count <= 13 никогда не выполняется по одному символу — Backspace «ломается».
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
            textField.resignFirstResponder()
            loginButtonTapped()
        }
        return true
    }
}
