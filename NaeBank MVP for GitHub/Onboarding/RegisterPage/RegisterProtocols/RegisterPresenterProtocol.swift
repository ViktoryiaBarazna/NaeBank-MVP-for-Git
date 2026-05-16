//
//  RegisterPresenterProtocol.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 11.05.26.
//

import Foundation

protocol RegisterPresenterProtocol: AnyObject {
    func registerTapped(
        phone: String?, password: String?, repeatPassword: String?, termsAccepted: Bool)
    func loginButtonDidTapped()
}
