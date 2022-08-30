//
//  Cache.swift
//  Poke iOS
//
//  Created by Davin Djayadi on 30/08/22.
//

import Foundation
import UIKit

struct Cache{
    private static let imageCache: NSCache<NSString, UIImage> = NSCache()
    
    static func isImageCached(key: NSString) -> Bool{
        return imageCache.object(forKey: key) != nil
    }
    static func getImageCache(key: NSString) -> UIImage{
        return imageCache.object(forKey: key)!
    }
    static func setImageCache(key: NSString, image: UIImage){
        imageCache.setObject(image, forKey: key)
    }
}
