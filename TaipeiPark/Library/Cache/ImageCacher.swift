//
//  ImageCacher.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/12.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

struct ImageCacher {
    
    static private let cache = NSCache<AnyObject, AnyObject>()
    
    static func loadImage(with url: URL, into imageView: UIImageView) {
        if let cachedImage = ImageCacher.cache.object(forKey: url as AnyObject) as? UIImage {
            imageView.image = cachedImage
        } else {
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: url) else { return }
                guard let image = UIImage(data: imageData) else { return }
                ImageCacher.cache.setObject(image as AnyObject, forKey: url as AnyObject)
                
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        }
    }
}


