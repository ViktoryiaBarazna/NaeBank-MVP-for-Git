//
//  RegisterProtocols.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 9.05.26.
//

import Foundation

protocol RegisterViewProtocol: AnyObject {
    func resetInvalidFieldHighlighting()
    func showInvalidFields(_ invalidFields: RegisterInvalidFields)
    func showAlert(title: String, message: String)
    func applyTrimmedPhone(_ phone: String)
}
