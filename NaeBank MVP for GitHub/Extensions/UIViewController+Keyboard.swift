//
//  UIViewController+Keyboard.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 22.05.26.
//

import UIKit

extension UIViewController {

    func setupDismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboardOnTap() {
        view.endEditing(true)
    }
}
