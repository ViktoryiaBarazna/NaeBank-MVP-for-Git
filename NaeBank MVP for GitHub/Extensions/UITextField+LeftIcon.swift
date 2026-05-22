//
//  UITextField+LeftIcon.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 22.05.26.
//

import UIKit

extension UITextField {

    func setLeftIcon(systemName: String, tintColor: UIColor) {
        let iconImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        iconImageView.image = UIImage(systemName: systemName)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = tintColor

        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 44))
        iconContainer.isUserInteractionEnabled = false
        iconContainer.addSubview(iconImageView)

        leftView = iconContainer
        leftViewMode = .always
    }
}
