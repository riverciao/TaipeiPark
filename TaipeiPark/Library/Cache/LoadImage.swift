//
//  LoadImage.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/12.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import Foundation
import UIKit

public protocol LoadImage {
    static func loadImage(with url: URL, into imageView: UIImageView)
    static func loadImage(with url: URL) -> UIImage
}
