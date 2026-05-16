//
//  NewsViewModel.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 4.05.26.
//

import Foundation

struct NewsViewModel {
    let news: [NewsAPIModel]
    let newsCellViewModels: [NewsCellViewModel]
    let title: String
    let errorMessage: String?
}
