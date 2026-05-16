//
//  ExchangeRatesPresenterProtocol.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 11.05.26.
//

import Foundation

protocol ExchangeRatesPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectRate(at index: Int)
}
