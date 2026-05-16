//
//  NewsRouter.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 4.05.26.
//

import UIKit

final class NewsRouter: NewsRouterProtocol {

    weak var viewController: UIViewController?

    func openDetails(for news: NewsAPIModel) {
        let detailVC = NewsDetailViewController.build(news: news)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
