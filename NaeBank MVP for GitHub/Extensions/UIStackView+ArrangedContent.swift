//
//  UIStackView+ArrangedContent.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 22.05.26.
//

import SnapKit
import UIKit

extension UIStackView {

    func addLabel(text: String, fontSize: CGFloat, isBold: Bool = false) {
        let label = UILabel()
        label.text = text
        label.textColor = .label
        label.numberOfLines = 0
        label.font = isBold ? .boldSystemFont(ofSize: fontSize) : .systemFont(ofSize: fontSize)
        addArrangedSubview(label)
    }

    func addSeparator() {
        let line = UIView()
        line.backgroundColor = .separator
        addArrangedSubview(line)
        line.snp.makeConstraints {
            $0.height.equalTo(1)
        }
    }
}
