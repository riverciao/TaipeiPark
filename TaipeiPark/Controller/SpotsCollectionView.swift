//
//  SpotsCollectionView.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/31.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class SpotsCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setUp()
        if let layout = layout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
            layout.scrollDirection = .horizontal
            layout.itemSize = itemSize(with: frame.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        self.backgroundColor = .lightGray
        self.showsHorizontalScrollIndicator = false
        self.register(UINib(nibName: SpotCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: SpotCollectionViewCell.identifier)
    }
    
    func itemSize(with viewHight: CGFloat) -> CGSize {
        let aspectRatio: CGFloat = 15/11
        let height = viewHight * 0.95
        let width = height / aspectRatio
        return CGSize(width: width, height: height)
    }
    
    class func viewHeight(with viewWidth: CGFloat) -> CGFloat {
        let aspectRatio: CGFloat = 0.4
        let height = viewWidth * aspectRatio
        if height < 220 {
            return height
        }
        return 220
    }
}
