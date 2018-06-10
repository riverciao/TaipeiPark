//
//  CustomAnnotationView.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/6/10.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import MapKit

public class CustomAnnotationView: MKAnnotationView {
    
    // MARK: Property

    public var callOutView: CallOutView?
    
    // MARK: Init
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    // MARK: SetUp
    private func setUp() {
        self.canShowCallout = false
    }
    
    // MARK: SetSelected
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            callOutView = CallOutView(frame: CGRect(x: 0, y: 0, width: 200, height: 130))
            guard let callOutView = callOutView else { return }
            self.addSubview(callOutView)
            
            // MARK: Setup CallOutView Layout
            callOutView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: self.calloutOffset.x).isActive = true
            callOutView.bottomAnchor.constraint(equalTo: self.topAnchor).isActive = true
        } else {
            callOutView?.removeFromSuperview()
        }
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside: Bool = rect.contains(point)
        if !isInside {
            for view in self.subviews {
                isInside = view.frame.contains(point)
                if isInside { break }
            }
        }
        return isInside
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let likeButton = callOutView?.likeButton.hitTest(convert(point, to: callOutView?.likeButton), with: event) {
            return likeButton
        }
        if let infoWindowButton = callOutView?.infoWindowButton.hitTest(convert(point, to: callOutView?.infoWindowButton), with: event) {
            return infoWindowButton
        }
        return nil
    }
}
