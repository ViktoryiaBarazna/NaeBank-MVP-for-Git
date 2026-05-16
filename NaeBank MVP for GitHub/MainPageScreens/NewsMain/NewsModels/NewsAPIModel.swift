//
//  NewsItem.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 26.04.26.
//

import Foundation

struct NewsAPIModel: Codable {
    let name_ru: String
    let img: String
    let html_ru: String
    let start_date: String
}
