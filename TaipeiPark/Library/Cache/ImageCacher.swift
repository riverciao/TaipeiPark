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
        
        // if already have image in cache, set image into imageView
        if let cachedImage = ImageCacher.cache.object(forKey: url as AnyObject) as? UIImage {
            imageView.image = cachedImage
        } else {
            
            // if do not have image in cache, make image request and save it in cache
            DispatchQueue.global().async {
                let request = URLRequest(url: url)
                let session = URLSession.shared
                request.responseData(urlSession: session, { (response) in
                    switch response.result {
                    case .success(let imageData):
                        guard let image = UIImage(data: imageData) else { return }
                        ImageCacher.cache.setObject(image as AnyObject, forKey: url as AnyObject)
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    case .failure:
                        break
                    }
                })
            }
        }
    }
}


