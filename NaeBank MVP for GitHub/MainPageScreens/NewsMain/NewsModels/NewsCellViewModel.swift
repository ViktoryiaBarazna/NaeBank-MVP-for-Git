//
//  NewsCellViewModel.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 4.05.26.
//

import Foundation

struct NewsCellViewModel {
    let newsName: String
    let newsDate: String

    init(from model: NewsAPIModel) {
        self.newsName = model.name_ru
        self.newsDate = model.start_date
    }
}
