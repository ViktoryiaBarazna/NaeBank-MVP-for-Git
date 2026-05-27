//
//  LoginPresenterProtocol.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 11.05.26.
//

import UIKit

protocol LoginPresenterProtocol: AnyObject {
    func loginButtonDidTapped(phone: String?, password: String?)
    func googleButtonTapped(presentingViewController: UIViewController)
    func registerButtonDidTapped()
}
