//
//  CustomPointAnnotationView.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/10.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import MapKit

class CustomPointAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    // MARK: SetUp
    private func setUp() {
        self.canShowCallout = false
    }
}
