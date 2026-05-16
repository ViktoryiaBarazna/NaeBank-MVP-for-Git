//
//  NewsProtocols.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 4.05.26.
//

import Foundation

protocol NewsViewProtocol: AnyObject {
    func showContent(_ viewModel: NewsViewModel)
    func showLoading()
    func hideLoading()
}
