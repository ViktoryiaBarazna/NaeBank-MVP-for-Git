//
//  String+Localizable.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 12.05.26.
//

import Foundation

extension String {

    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    func localized(_ args: CVarArg...) -> String {
        String(format: NSLocalizedString(self, comment: ""), locale: nil, arguments: args)
    }
}
