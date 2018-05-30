//
//  UIImageViewExtension.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/30.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url) else { return }
            guard let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
