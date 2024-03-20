//
//  ImageLoader.swift
//  Handshake
//
//  Created by Yariv on 3/19/24.
//

import Foundation
import UIKit.UIImage

protocol ImageLoader {
    @discardableResult func loadImage(for url: URL) async throws -> UIImage?
    subscript(url: URL?) -> UIImage? { get }
}

final class ImageLoaderImpl: ImageLoader {
    let cache: ImageCache
    let networkController: NetworkController
    
    init(cache: ImageCache = ImageCache(), networkController: NetworkController = NetworkControllerImpl()) {
        self.cache = cache
        self.networkController = networkController
    }
    
    subscript(url: URL?) -> UIImage? { cache[url] }
    
    func loadImage(for url: URL) async throws -> UIImage? {
        if let image = cache[url] {
            return image
        }
        let image = try await networkController.getImage(url: url)
        cache[url] = image
        return image
    }
}
