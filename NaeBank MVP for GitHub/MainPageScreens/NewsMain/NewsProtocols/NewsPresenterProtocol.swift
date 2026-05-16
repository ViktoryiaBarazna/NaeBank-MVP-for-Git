//
//  NewsPresenterProtocol.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 11.05.26.
//

import Foundation

protocol NewsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectNews(at index: Int)
}
