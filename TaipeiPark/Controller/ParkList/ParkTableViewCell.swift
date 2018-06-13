//
//  ParkTableViewCell.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/27.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class ParkTableViewCell: UITableViewCell {
    
    static var identifier: String { return String(describing: self) }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var administrativeAreaLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var parkImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    var isLiked = false {
        didSet {
            likeButton.tintColor = isLiked ?
                UIColor.likedColor : UIColor.unlikedColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    private func setUp() {
        parkImageView.contentMode = .scaleAspectFit
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = #imageLiteral(resourceName: "icon-photo").withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .imagePlaceholderColor
        
        mapButton.backgroundColor = .mapButtonColor
        mapButton.setTitleColor(.white, for: .normal)
        
        likeButton.tintColor = .unlikedColor
        likeButton.setImage(
            #imageLiteral(resourceName: "icon-star").withRenderingMode(.alwaysTemplate),
            for: .normal
        )
    }
}
