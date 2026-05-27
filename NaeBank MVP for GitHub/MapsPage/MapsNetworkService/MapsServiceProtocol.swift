//
//  MapsServiceProtocol.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 24.05.26.
//

import Foundation

protocol MapsServiceProtocol {
    func fetchBranches(completion: @escaping (Result<[BranchMapItem], NetworkError>) -> Void)
}
