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
    var centerCoordinate: CLLocationCoordinate2D? {
        didSet {
            guard let coordinate = centerCoordinate else { return }
            setRegion(centerCoordinate: coordinate)
        }
    }
    var selectedPark: Park?
    var currentAnnotatoin: CustomPointAnnotation? {
        willSet {
            guard
                let previousAnnotation = currentAnnotatoin,
                let annotationView = locationView.mapView.view(for: previousAnnotation)
            else { return }
            removeCallOutView(for: annotationView)
        }
    }
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        currentAnnotatoin = nil
    }
    
    // MARK: Setup
    
    private func setUp() {
        // MARK: LocationView
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0
        locationView = LocationView(frame: CGRect(x: 0, y: navigationBarHeight, width: view.frame.width, height: view.frame.height - tabBarHeight - navigationBarHeight))
        view.addSubview(locationView)

        locationView.mapView.delegate = self
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
    
    private func removeCallOutView(for annotationView: MKAnnotationView) {
        let callOutViews = annotationView.subviews
        for view in callOutViews {
            view.removeFromSuperview()
        }
    }
    
    private func annotationView(of park: Park, in views: [CustomAnnotationView]) -> CustomAnnotationView? {
        for view in views {
            guard let annotation = view.annotation as? CustomPointAnnotation else { break }
            if annotation.park == park {
                return view
            }
        }
        return nil
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
        else { return }
        
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
            let alert = UIAlertController(title: "\(error)", message: error.localizedDescription, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
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
        if centerCoordinate == nil {
            if let userLocation = locations.last {
                centerCoordinate = userLocation.coordinate
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
    
    ///Set park data and add target to buttons to callOutView
    func setup(_ callOutView: CallOutView, with annotation: CustomPointAnnotation) {
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
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
        // MARK: Open callOutView if park is selected in .list
        guard
            let park = self.selectedPark,
            let annotationViews = views as? [CustomAnnotationView],
            let annotationView = annotationView(of: park, in: annotationViews)
        else { return }
        
        annotationView.setSelected(true, animated: false)
        
        guard
            let callOutView = annotationView.callOutView,
            let annotation = annotationView.annotation as? CustomPointAnnotation
        else { return }
        setup(callOutView, with: annotation)
        currentAnnotatoin = annotation
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let pinCoordinate = view.annotation?.coordinate {
            setRegion(centerCoordinate: pinCoordinate)
        }
        guard
            let view = view as? CustomAnnotationView,
            let annotation = view.annotation as? CustomPointAnnotation,
            let callOutView = view.callOutView
        else { return }
        currentAnnotatoin = annotation
        setup(callOutView, with: annotation)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        currentAnnotatoin = nil
    }
}

extension LocationViewController: ParkProviderDelegate {
    func didFetch(by provider: ParkProvider) {
        reloadAnnotations()
    }
    
    func didFail(with error: Error, by provider: ParkProvider) {
        let alert = UIAlertController(title: "\(error)", message: error.localizedDescription, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

extension LocationViewController: LikedParkLocalProviderDelegate {
    func didFail(with error: Error, by provider: LikedParkProvider) {
        let alert = UIAlertController(title: "\(error)", message: error.localizedDescription, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
