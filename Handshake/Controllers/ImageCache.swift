//
//  ImageCache.swift
//  Handshake
//
//  Created by Yariv on 3/19/24.
//

import Foundation
import UIKit.UIImage

class ImageCache {
    private let imageCache = NSCache<NSURL, UIImage>()
    
    subscript(url: URL?) -> UIImage? {
        get {
            guard let url = url else { return nil }
            return imageCache.object(forKey: url as NSURL)
        }
        set {
            guard let url, let image = newValue else { return }
            imageCache.setObject(image, forKey: url as NSURL)
        }
    }
}
