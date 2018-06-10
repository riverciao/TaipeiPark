//
//  CallOutView.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/9.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

public class CallOutView: UIView {

    lazy var infoWindowButton: UIButton = {
        let button = UIButton()
        button.tintColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var infoWindowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "view-callout")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "title"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "subtitle"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Content"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        let image = #imageLiteral(resourceName: "icon-star").withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.likedColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var isLiked: Bool = false {
        didSet {
            likeButton.tintColor = isLiked ? .likedColor : .unlikedColor
        }
    }
    
    var isOpened: Bool = false {
        didSet {
            contentLabel.text = isOpened ? "營業中" : "休息中"
            contentLabel.textColor = isOpened ? .openedColor : .closedColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    // MARK: Setup
    
    private func setUp() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(infoWindowImageView)
        infoWindowImageView.allConstraints(equalTo: self)
        
        infoWindowImageView.addSubview(infoWindowButton)
        infoWindowButton.allConstraints(equalTo: infoWindowImageView)
        
        infoWindowButton.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: infoWindowButton.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: infoWindowButton.leftAnchor, constant: 16).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: self.bounds.width * 0.75).isActive = true
        
        infoWindowButton.addSubview(subtitleLabel)
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        subtitleLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        
        infoWindowButton.addSubview(contentLabel)
        contentLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8).isActive = true
        contentLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        
        infoWindowButton.addSubview(likeButton)
        likeButton.topAnchor.constraint(equalTo: titleLabel.topAnchor).isActive = true
        likeButton.rightAnchor.constraint(equalTo: infoWindowButton.rightAnchor, constant: -16).isActive = true
    }
}
