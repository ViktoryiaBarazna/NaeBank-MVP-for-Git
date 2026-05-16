//
//  ImageLoadingService.swift
//  NaeBank
//
//  Created by Виктория Дисбаланс on 11.05.26.
//
import UIKit

final class ImageLoadingService: ImageLoadingServiceProtocol {
    static let shared = ImageLoadingService()

    private let session: URLSession
    private let cache = NSCache<NSURL, UIImage>()

    init(session: URLSession = .shared) { self.session = session }

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cached = cache.object(forKey: url as NSURL) {
            completion(cached)
            return
        }

        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil, let http = response as? HTTPURLResponse,
                (200...299).contains(http.statusCode), let data, let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }

            self?.cache.setObject(image, forKey: url as NSURL)
            completion(image)
        }
        task.resume()
    }
}
