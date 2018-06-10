//
//  LocationViewController.swift
//  TaipeiPark
//
//  Created by riverciao on 2018/5/29.
//  Copyright © 2018年 riverciao. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {

    // MARK: Property
    
    let provider: ParkProvider
    var likedParkProvider: LikedParkProvider? {
        didSet {
            likedParkProvider?.likedParkdelegate = self
        }
    }
    var persistenceDelegate: PersistenceDelegate?
    var locationManager = CLLocationManager()
    var locationView: LocationView!
    var centerLocation: CLLocation?
    
    // MARK: Init
    
    init(provider: ParkProvider) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
        provider.delegate = self
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadAnnotations()
    }
    
    // MARK: Setup
    
    private func setUp() {
        // MARK: LocationView
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        locationView = LocationView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.frame.width, height: view.frame.height - tabBarHeight - navigationBarHeight))
        view.addSubview(locationView)

        locationView.mapView.delegate = self
        provider.fetch()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: Action
    
    private func setRegion(centerCoordinate: CLLocationCoordinate2D) {
        let viewRegion = MKCoordinateRegionMakeWithDistance(centerCoordinate, 1000, 1000)
        locationView.mapView.setRegion(viewRegion, animated: false)
    }
    
    private func reloadAnnotations() {
        let mapView = locationView.mapView
        mapView.removeAnnotations(mapView.annotations)
        for park in provider.parks {
            
            // Check if now is in park open time
            let parkOpenTime = park.openTime ?? "00:00~24:00"
            let now = Date()
            let isInOpenTime = now.isInOpenTime(parkOpenTime)
            
            var annotation = CustomPointAnnotation(pinType: .open, park: park)
            if !isInOpenTime {
                annotation = CustomPointAnnotation(pinType: .close, park: park)
            }
            
            DispatchQueue.main.async {
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    @objc func likePark(_ sender: UIButton) {
        guard
            let persistenceDelegate = persistenceDelegate,
            let likedParkProvider = likedParkProvider
            else { fatalError("make sure persistenceDelegate and likedParkProvider are assigned") }
        
        let parkIndex = sender.tag
        let park = provider.park(at: IndexPath(row: parkIndex, section: 0))
        
        do {
            try persistenceDelegate.performTask(in: .main) { (context) in
                
                let isLiked = likedParkProvider.isLikedPark(id: park.id)
                if isLiked {
                    try likedParkProvider.removeLikedPark(id: park.id)
                    try context.save()
                } else {
                    try likedParkProvider.likePark(park)
                    try context.save()
                }
                
                // MARK: Update UI
                guard
                    let annotationView = sender.superview?.superview?.superview?.superview as? CustomAnnotationView,
                    let annotation = annotationView.annotation as? CustomPointAnnotation
                    else { return }
                
                let park = annotation.park
                annotationView.callOutView?.isLiked = likedParkProvider.isLikedPark(id: park.id)
            }
        } catch {
            
            // TODO: ErrorHandle
            print("error: \(error)")
        }
    }
    
    @objc func pushToParkDetail(_ sender: UIButton) {
        guard
            let annotationView = sender.superview?.superview?.superview as? CustomAnnotationView,
            let annotation = annotationView.annotation as? CustomPointAnnotation
            else { return }
        
        let currentPark = annotation.park
        let client = APIClient()
        let provider = ParkDetailAPIProvider(client: client)
        let parkDetailViewController = ParkDetailViewController(provider: provider)
        provider.fetchFacility(by: currentPark.name)
        provider.fetchSpot(by: currentPark.name)
        parkDetailViewController.currentPark = currentPark
        
        self.navigationController?.pushViewController(parkDetailViewController, animated: true)
    }
}

extension LocationViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Zoom to user location
        if centerLocation == nil {
            if let userLocation = locations.last {
                centerLocation = userLocation
                setRegion(centerCoordinate: userLocation.coordinate)
            }
        }
    }
    
    // MARK: MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customPointAnnotation = annotation as? CustomPointAnnotation else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomPointAnnotation.identifier)
        if annotationView == nil {
            annotationView = CustomAnnotationView(annotation: customPointAnnotation, reuseIdentifier: CustomPointAnnotation.identifier)
        } else {
            annotationView?.annotation = customPointAnnotation
        }
        
        annotationView?.image = customPointAnnotation.pinType.image
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let pinCoordinate = view.annotation?.coordinate {
            setRegion(centerCoordinate: pinCoordinate)
        }

        guard
            let view = view as? CustomAnnotationView,
            let annotation = view.annotation as? CustomPointAnnotation,
            let callOutView = view.callOutView else { return }
        
        // MARK: Park data to callOutView
        let park = annotation.park
        callOutView.titleLabel.text = park.name
        callOutView.subtitleLabel.text = park.administrativeArea
        callOutView.isLiked = likedParkProvider?.isLikedPark(id: park.id) ?? false
        callOutView.isOpened = {
            switch annotation.pinType {
            case .open: return true
            case .close: return false
            }
        }()
         
        guard let parkIndex = provider.parks.index(of: park) else { return }
        callOutView.likeButton.tag = parkIndex
        callOutView.likeButton.addTarget(self, action: #selector(likePark), for: .touchUpInside)
        callOutView.infoWindowButton.addTarget(self, action: #selector(pushToParkDetail), for: .touchUpInside)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        let callOutViews = view.subviews
        for view in callOutViews {
            view.removeFromSuperview()
        }
    }
}

extension LocationViewController: ParkProviderDelegate {
    func didFetch(by provider: ParkProvider) {
        reloadAnnotations()
        
        // Map Loading Scale
        //            let mapContainsPoint = MKMapRectContainsPoint((locationView.mapView.visibleMapRect)!, MKMapPointForCoordinate(park.coordinate))
        //            let annotations = locationView.mapView.annotations(in: (locationView.mapView.visibleMapRect)!)
    }
    
    func didFail(with error: Error, by provider: ParkProvider) {
        print(error)
    }
}

extension LocationViewController: LikedParkLocalProviderDelegate {
    func didFail(with error: Error, by provider: LikedParkProvider) {
        print(error)
    }
}
