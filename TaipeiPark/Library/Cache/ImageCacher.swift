//
//  ImageCacher.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/12.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

struct ImageCacher {

    static private var imageCache = [URL: Data]()
    
    static func loadImage(with url: URL, into imageView: UIImageView) {
        
        // if already have image in cache, set image into imageView
        if let imageData = imageCache[url] {
            guard let image = UIImage(data: imageData) else { return }
            imageView.image = image
        } else {
            
            // if do not have image in cache, make image request and save it in cache
            DispatchQueue.global().async {
                let request = URLRequest(url: url)
                let session = URLSession.shared
                request.responseData(urlSession: session, { (response) in
                    switch response.result {
                    case .success(let imageData):
                        guard let image = UIImage(data: imageData) else { return }
                        DispatchQueue.main.async {
                            UIView.transition(with: imageView, duration: 0.5, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
                                imageView.image = image
                            }, completion: nil)
                        }
                        imageCache[url] = imageData
                    case .failure:
                        break
                    }
                })
            }
        }
    }
}


