//
//  LocationManager.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 22/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import CoreLocation
//import GoogleMaps

final class LocationManager: NSObject {
    
    static let manager = LocationManager()
    
    private let clGeocoder = CLGeocoder()
//    private let gmsGeocoder = GMSGeocoder()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    var getUserCurrentLocation: ((_ coordinates: CLLocationCoordinate2D)->Void)? {
        didSet {
            if getUserCurrentLocation != nil {
                self.locationManager.requestWhenInUseAuthorization()
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    locationManager.startUpdatingLocation()
                }
            }
        }
    }
    
//    func getAddress(from coordinates: CLLocationCoordinate2D, completion: ((_ gmsAddress: GMSAddress?, _ error: Error?)->Void)?) {
//        gmsGeocoder.reverseGeocodeCoordinate(coordinates, completionHandler: { (response, error) in
//            if let err = error {
//                print(err.localizedDescription)
//                completion?(nil, err)
//            } else if let resultAddress = response?.firstResult() {
//                completion?(resultAddress, nil)
//            }
//        })
//    }
    
    func getCoordinatesByAddress(address: String, completion: ((_ clgeocode: [CLPlacemark]?, _ error: Error?)->Void)?) {
        clGeocoder.geocodeAddressString(address) { (response, error) in
            if let err = error {
                print(err.localizedDescription)
                completion?(nil, err)
            } else if let resultAddress = response {
                completion?(resultAddress, nil)
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        manager.stopUpdatingLocation()
        getUserCurrentLocation?(locValue)
        getUserCurrentLocation = nil
    }
}
