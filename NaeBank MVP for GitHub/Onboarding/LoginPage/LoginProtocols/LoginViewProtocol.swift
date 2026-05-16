//
//  LoginProtocols.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 10.05.26.
//

import Foundation

protocol LoginViewProtocol: AnyObject {
    func resetInvalidFieldHighlighting()
    func showInvalidFields(_ invalidFields: LoginInvalidFields)
    func showAlert(title: String, message: String)
    func applyTrimmedPhone(_ phone: String)
    func clearPasswordField()
}
