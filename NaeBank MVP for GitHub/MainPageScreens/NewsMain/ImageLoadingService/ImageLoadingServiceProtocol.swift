//
//  ImageLoadingServiceProtocol.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 11.05.26.
//

import UIKit

protocol ImageLoadingServiceProtocol {
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void)
}
