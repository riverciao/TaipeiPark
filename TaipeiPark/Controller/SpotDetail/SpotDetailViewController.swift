//
//  SpotDetailViewController.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/5.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit

class SpotDetailViewController: UIViewController {

    // MARK: Property
    
    let currentSpot: Spot
    var spotDetailView: SpotDetailView!
    
    // MARK: Init
    
    init(spot: Spot) {
        self.currentSpot = spot
        super.init(nibName: nil, bundle: nil)
        addSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Setup
    
    private func addSubview() {
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let spotDetailViewHeight = view.bounds.height - navigationBarHeight
        spotDetailView = SpotDetailView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.frame.width, height: spotDetailViewHeight))
        if let spotDetailView = spotDetailView {
            view.addSubview(spotDetailView)
        }
    }
    
    private func setup() {
        self.tabBarController?.tabBar.isHidden = true

        if let imageURL = currentSpot.imageURL {
            ImageCacher.loadImage(with: imageURL, into: spotDetailView.spotImageView)
        }
        spotDetailView.parkNameLabel.text = currentSpot.parkName
        spotDetailView.spotNameLabel.text = currentSpot.name
        spotDetailView.openTimeLabel.text = currentSpot.openTime
        spotDetailView.introductionLabel.text = currentSpot.introduction
    }
}
