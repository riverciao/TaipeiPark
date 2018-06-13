//
//  SpotCollectionViewCell.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/31.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class SpotCollectionViewCell: UICollectionViewCell {
    
    class var identifier: String { return String(describing: self) }
    
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var spotImageView: UIImageView!
    @IBOutlet weak var spotName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    private func setUp() {
        iconImageView.image = #imageLiteral(resourceName: "icon-photo").withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .imagePlaceholderColor
        iconImageView.contentMode = .scaleAspectFit
    }
}
