//
//  ImageCacher.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/12.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class ImageCacher: LoadImage {
    
    static func loadImage(with url: URL, into imageView: UIImageView) {
        let memoryCache = MemoryCache()
        let diskCache = DiskCache()
        
        // If stored in menory and disk
        let isExistedInMemory = memoryCache.fileExists(for: url)
        let isExistedInDisk = diskCache.fileExists(for: url)
        
        switch (isExistedInMemory, isExistedInDisk) {
        case (true, _):
            // retrieve from memory
            memoryCache.retrieve(for: url) { (image: UIImage) in
                DispatchQueue.main.async {
                    imageView.image = image
                }
            }
        case (false, true):
            // retrieve from disk and save to memory
            diskCache.retrieve(for: url) { (image: UIImage) in
                DispatchQueue.main.async {
                    imageView.image = image
                }
                memoryCache.store(object: image, for: url, completion: nil)
            }
        case (false, false):
            // save to memory and disk and retrieve
            guard let imageData = try? Data(contentsOf: url) else { return }
            guard let image = UIImage(data: imageData) else { return }
            memoryCache.store(object: image, for: url) {
                memoryCache.retrieve(for: url) { (image: UIImage) in
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
                diskCache.store(object: image, for: url, completion: nil)
            }
        }
    }
    
    static func loadImage(with url: URL) -> UIImage {
        return UIImage()
    }
}


