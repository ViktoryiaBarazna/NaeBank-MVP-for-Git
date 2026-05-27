//
//  BranchClientType.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 24.05.26.
//

import Foundation

enum BranchClientType: String {
    case individual
    case business

    init(apiSegment: String?) {
        self = Self(rawValue: apiSegment?.lowercased() ?? "") ?? .individual
    }

    var localizedSubtitle: String {
        switch self {
        case .individual: "maps_branch_individual".localized
        case .business: "maps_branch_business".localized
        }
    }
}
