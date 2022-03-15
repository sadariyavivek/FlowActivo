//
//  LocationCell.swift
//  Essentials
//
//  Created by Stegowl Macbook Pro on 20/07/20.
//  Copyright © 2020 Ravi. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class LocationCell: CoreTableViewCell {

    //MARK:- IBOutlets
    @IBOutlet weak var appointMentView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lblAddress: CoreLabel!
    
    var provide: UserData? {
        didSet {
            showMarker(lat: provide?.latitude ?? "", long: provide?.longitude ?? "", title: provide?.businessname ?? "")
            lblAddress.text = provide?.address
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        do { if let styleURL = Bundle.main.url(forResource: "map_style", withExtension: "json") {
            self.mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
        } else { }
        } catch {   }
    }
    
    func showMarker(lat: String, long: String, title: String){
        let camera = GMSCameraPosition.camera(withLatitude: CLLocationDegrees(lat.toDouble), longitude: CLLocationDegrees(long.toDouble), zoom: 14.0)
        self.mapView.camera = camera
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat.toDouble), longitude: CLLocationDegrees(long.toDouble)))
        marker.icon = UIImage(named: "ic_pin") // Marker icon
        marker.title = title
        marker.map = mapView
    }
}
